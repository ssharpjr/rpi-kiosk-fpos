#!/bin/bash

# Shortcut for "baking" Raspberry Pi images.
# This script can bake zipped or raw images.

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
    exit 1
fi

FILENAME="$1"
BLOCK_DEVICE="$2"
FILE_SIZE=$(du -sb $FILENAME | awk -F " " '{print$1}')

# Check if Block Device exists
if ! [[ -e "$BLOCK_DEVICE" ]]; then
    echo ""
    echo "ERROR: Block device $BLOCK_DEVICE not detected."
    echo "Verify that your SD Card and/or adapter are properly connected."
    echo ""
    exit 1
fi

# Check if pv is installed
PV="/usr/bin/pv"

# Check image format (IMG or ZIP)
FILE_TYPE=$(file -b $FILENAME | awk -F " " '{print $1}')
if [[ "$FILE_TYPE" == "Zip" ]]; then
    # It's a ZIP file
    # echo "ZIP file detected"
    if [[ -f "$PV" ]]; then
    FLASH_CMD="zip -p $FILENAME | pv -petbars $FILE_SIZE | sudo dd of=$BLOCKDEVICE bs=4M"
    else
    FLASH_CMD="zip -p $FILENAME | sudo dd of=$BLOCKDEVICE bs=4M status=progress"
    fi
    
elif [[ "$FILE_TYPE" == "DOS/MBR" ]]; then
    # It's a bootable image
    # echo "Bootable image detected"
    if [[ -f "$PV" ]]; then
        FLASH_CMD="dd if=$FILENAME | pv -petbars $FILE_SIZE | dd bs=4M of=$BLOCK_DEVICE"
        # FLASH_CMD="dd if=$FILENAME of=$BLOCK_DEVICE bs=4M"
    else
        FLASH_CMD="sudo dd if=$FILENAME of=$BLOCK_DEVICE bs=4M status=progress"
    fi
else
    echo ""
    echo "ERROR: Cannot confirm file type. Verify the image is correct."
    echo ""
    exit 1
fi

# Bake the pi!
echo ""
echo "'$FILENAME'    will be flashed to    '$BLOCK_DEVICE'    using the command:"
echo ""
echo "====>    $FLASH_CMD    <===="
echo ""
echo ""
read -p "Press ENTER to continue or CTRL+C to cancel."
echo ""
echo "Baking the Pi!"
echo "------------------------------------------------------------"

eval "$FLASH_CMD"
