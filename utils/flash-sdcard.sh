#!/bin/bash

# Shortcut for "baking" Raspberry Pi images

# Must be run as root!
if [[ $EUID -ne 0 ]]; then
    echo ""
    echo "Must be run as root!"
    echo ""
    exit 0
fi

# Welcome
echo ""
echo "Raspberry Pi Baking Script"
echo "--------------------------"
echo ""

# Usage check
if [[ -z "$1" ]] || [[ -z "$2" ]]; then
    echo ""
    echo "Usage $0 <IMAGE_NAME> /dev/<BLOCK_DEVICE>"
    echo ""
    echo "Run with the image name and the device you are writing to."
    echo "Example: $0 pi_os.img /dev/sdb"
    echo "Use 'lsblk' to find your block device"
    echo ""
    exit 0
fi

FILENAME="$1"
BLOCK_DEVICE="$2"

# Check if Block Device exists
if ! [[ -e "$BLOCK_DEVICE" ]]; then
    echo ""
    echo "ERROR: Block device $BLOCK_DEVICE not detected."
    echo "Verify that your SD Card and/or adapter are properly connected."
    echo ""
    exit 1
fi

# Check image format (IMG or ZIP)
FILE_TYPE=$(file -b $FILENAME | awk -F " " '{print $1}')
if [[ "$FILE_TYPE" == "Zip" ]]; then
    # It's a ZIP file
    echo "ZIP file detected"
    FLASH_CMD="zip -p $FILENAME | dd of=$BLOCKDEVICE bs=4M status=progress"
elif [[ "$FILE_TYPE" == "DOS/MBR" ]]; then
    # It's a bootable image
    echo "Bootable image detected"
    FLASH_CMD="dd if=$FILENAME of=$BLOCK_DEVICE bs=4M status=progress"
else
    echo ""
    echo "ERROR: Cannot confirm file type. Verify the image is correct."
    echo ""
    exit 1
fi

# Bake the pi!
echo ""
echo "$FILENAME will be flashed to $BLOCK_DEVICE using the command:"
echo "    $FLASH_CMD"
echo ""
read -p "Press ENTER to continue or CTRL+C to cancel."
echo ""
echo "Baking the Pi!"
echo "------------------------------------------------------------"
$FLASH_CMD
