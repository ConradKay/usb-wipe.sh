#!/bin/bash

LOGFILE="/var/log/wipe_device.log"
SUCCESS=0
ERROR_INVALID_DEVICE=1
ERROR_NOT_ROOT=2
ERROR_UNMOUNT=3
ERROR_WIPE=4

function log {
  echo "$(date): $1" | tee -a "$LOGFILE"
}

function show_help {
  echo "Usage: $0 [OPTIONS]"
  echo "Wipe a selected block device."
  echo "  -d, --dry-run    Show the actions without actually performing them."
  echo "  -h, --help       Display this help message."
  exit $SUCCESS
}

DRY_RUN=false

while getopts "dh" opt; do
  case $opt in
    d)
      DRY_RUN=true
      ;;
    h)
      show_help
      ;;
    *)
      echo "Unknown option: $opt"
      show_help
      ;;
  esac
done
shift $((OPTIND - 1))

log "Starting wipe script."

if [ "$(id -u)" != "0" ]; then
  log "This script must be run as root. Use 'sudo $0' to run it with administrative privileges."
  exit $ERROR_NOT_ROOT
fi

echo "Available USB devices:"
USB_DEVICES=$(lsblk -d -o NAME,TRAN | grep 'usb' | awk '{print "/dev/" $1}')
echo "$USB_DEVICES" | nl
log "Listed available USB devices."

read -rp "Please enter the number corresponding to the device you want to wipe: " DEVICE_NUM

DEVICE=$(echo "$USB_DEVICES" | sed -n "${DEVICE_NUM}p")

if [ -z "$DEVICE" ]; then
  log "Error: Invalid selection. Please enter a correct number."
  exit $ERROR_INVALID_DEVICE
fi

DEVICE_INFO=$(lsblk -o SIZE,FSTYPE,LABEL "$DEVICE" | sed -n '2p')

echo "Selected device details:"
echo "$DEVICE_INFO"

read -rp "Are you sure you want to wipe out $DEVICE? All data will be lost! (y/n, default=n): " -n 1 -r REPLY
echo

if [[ ! $REPLY =~ ^[Yy]$ ]]; then
  exit $SUCCESS
fi

echo "Unmounting $DEVICE..."
if ! $DRY_RUN && ! umount "$DEVICE"*; then
  log "Error: Failed to unmount $DEVICE. Please unmount it manually and try again."
  exit $ERROR_UNMOUNT
elif $DRY_RUN; then
  echo "[DRY-RUN] Would attempt to unmount $DEVICE."
fi

echo "Wiping $DEVICE..."
if $DRY_RUN; then
  echo "[DRY-RUN] Would attempt to wipe $DEVICE."
elif ! dd if=/dev/zero of="$DEVICE" bs=4M status=progress; then
  log "Error: Failed to wipe $DEVICE. Check if the device is in use, has other issues, or if there's not enough permissions."
  exit $ERROR_WIPE
fi

if ! $DRY_RUN; then
  sync
else
  echo "[DRY-RUN] Would have synced data to the device."
fi

log "Wipe complete. $DEVICE has been erased."
exit $SUCCESS

