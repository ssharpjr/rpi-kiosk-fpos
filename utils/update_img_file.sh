#!/bin/bash

# Change files on an image file

# Must run as root
if [[ $EUID -ne 0 ]]; then
  echo ""
  echo "Must be run as root!"
  exit 1
fi

# Usage check
if [[ -z "$1" ]] || [[ -z "$2"  ]] || [[ -z "$3" ]] ; then
  echo ""
  echo "Usage: $0 <IMAGE_FILE> <HOSTNAME> <PM_ID>"
  echo ""
  echo "Run with the Image_file, HOSTNAME, and PM_ID."
  echo "Example: $0 line05-pi pm0021"
  exit 1
fi


# Set/Check for directories and files
IMAGE_NAME="$1"
NEW_HOSTNAME="$2"
PM_ID="$3"
BOOT_DIR="/mnt/img/boot"
ROOT_DIR="/mnt/img/root"
MNT_IMG_SH="/usr/local/bin/mount_rpi_img.sh"
if ! [[ -f "$MNT_IMG_SH" ]]; then
    echo "$MNT_IMG_SH is missing"
    echo "Make sure the $MNT_IMG_SH script is in /usr/local/bin."
    exit 1
fi

# Mount image BOOT partition and update files
echo "Mounting BOOT"
$MNT_IMG_SH $IMAGE_NAME boot
FPOS_FILE="/mnt/img/boot/fullpageos.txt"
LINK_URL="http://10.0.1.89/Pages/Production/DisplayP1BonusNew.aspx?LineNo="

if ! [[ -f "$FPOS_FILE" ]]; then
    echo ""
    echo "Error finding $FPOS_FILE"
    echo "Exiting"
    exit 1
fi

echo ""
echo "Updating FullPageOS link file"
NEW_LINK_URL=${LINK_URL}${PM_ID}
echo $NEW_LINK_URL > $FPOS_FILE
echo "Unmounting BOOT"
umount $BOOT_DIR

# Mount image ROOT partition and update files
echo "Mounting ROOT"
$MNT_IMG_SH $IMAGE_NAME root
HOSTS_FILE="$ROOT_DIR/etc/hosts"
HOSTNAME=$(cat $ROOT_DIR/etc/hostname)
CHROMIUM_CONFIG_DIR="$ROOT_DIR/home/pi/.config/chromium"
CHROMIUM_CACHE_DIR="$ROOT_DIR/home/pi/.cache/chromium"

if ! [[ -f "$HOSTS_FILE" ]]; then
    echo ""
    echo "Error finding $HOSTS_FILE"
    umount $ROOT_DIR
    echo "Exiting"
    exit 1
fi

echo ""
echo "Updating Hostname and the Hosts file"
echo ${NEW_HOSTNAME} | sudo tee $ROOT_DIR/etc/hostname
sudo sed -i "s/127\.0\.1\.1\t${HOSTNAME}/127\.0\.1\.1\t${NEW_HOSTNAME}/g" \
    $ROOT_DIR/etc/hosts
# Sometimes there is a double tab?
sudo sed -i "s/127\.0\.1\.1\t\t${HOSTNAME}/127\.0\.1\.1\t${NEW_HOSTNAME}/g" \
    $ROOT_DIR/etc/hosts

echo "Deleting Chromium files"
rm -rf $CHROMIUM_CONFIG_DIR
rm -rf $CHROMIUM_CACHE_DIR

echo "Unmounting ROOT"
umount $ROOT_DIR

echo "Done"
exit 0