# usb-wipe.sh the USB Device Wiping Utility

This command-line tool provides a convenient way to securely wipe USB devices on Linux systems. It features both dry-run and execution modes, detailed logging, and multiple user confirmation steps to prevent accidental data loss.

## Table of Contents

- [Features](#features)
- [Requirements](#requirements)
- [Installation](#installation)
- [Usage](#usage)
- [Warning](#warning)
- [License](#license)

## Features

- Lists available USB devices for selection.
- Confirms device selection and provides details before wiping.
- Option for a dry-run to see the actions without performing them.
- Logs all actions and errors to a log file.
- Requires root privileges to ensure proper execution.

## Requirements

- Bash shell
- Standard Linux utilities such as `lsblk`, `grep`, `awk`, `dd`

## Installation

1. Clone this repository:
`git clone https://github.com/yourusername/usb-wipe.git`
2. Make the script executable:
`chmod +x usb-wipe.sh`


## Usage

Run the script with root privileges:


`sudo ./usb-wipe.sh [OPTIONS]`
## Options

`-d, --dry-run: Show the actions without actually performing them.`

`-h, --help: Display help message.`

Follow the on-screen instructions to safely and securely wipe your USB device.

## WARNING
This tool performs a destructive action on the selected USB device. All data will be completely erased without recovery. Please use caution and ensure that you have selected the correct device before confirming the wipe operation.

## License

This project is licensed under the MIT License - see the LICENSE file for details.
