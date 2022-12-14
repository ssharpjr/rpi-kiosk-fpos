#! /bin/bash

# Simple script for mounting a standard format Raspberry Pi image
# A standard image should consist of 2 partitions:
# 1: boot
# 2: root

# Must run as root
if [[ $EUID -ne 0 ]]; then
  echo ""
  echo "Must be run as root!"
  exit 0
fi

# Usage check
if [[ -z "$1" ]] || [[ -z "$2"  ]] ; then
  echo ""
  echo "Usage: $0 <IMAGE_NAME> <boot or root>"
  echo ""
  echo "Run with an image name followed by 'boot' or 'root' "
  echo "to mount that partition from the image."
  exit 0
fi

# Get or make mount dirs
boot_dir="/mnt/img/boot"
root_dir="/mnt/img/root"
if ! [[ -d "$boot_dir" ]]; then
  echo "Creating $boot_dir"
  mkdir -p $boot_dir
fi
if ! [[ -d "$root_dir" ]]; then
  echo "Creating $root_dir"
  mkdir -p $root_dir
fi

# Get image details
sector=$(fdisk -u -l $1 | grep "Units" | awk -F " " '{print $8}')
boot_start=$(fdisk -u -l $1 | grep "$1"1 | awk -F " " '{print $2}')
root_start=$(fdisk -u -l $1 | grep "$1"2 | awk -F " " '{print $2}')
extra_start=$(fdisk -u -l $1 | grep "$1"3 | awk -F " " '{print $2}')

# Abort if more than 2 partitions are found
if ! [[ -z "$extra_start" ]]; then
  echo ""
  echo "************"
  echo "More than 2 partitions found in this image."
  echo "Aborting!"
  echo "************"
  echo ""
  exit 0
fi


boot_sector=$(($sector * $boot_start))
root_sector=$(($sector * $root_start))

# echo ""
# echo "      Sector Size: $sector"
# echo "       Boot Start: $boot_start"
# echo "       Root Start: $root_start"
# echo "Boot Start Sector: $boot_sector"
# echo "Root Start Sector: $root_sector"

# Mount image partitions
if [[ "$2" == "boot" ]]; then
  umount $boot_dir 2&>1 > /dev/null
  mount -o loop,offset=$boot_sector $1 $boot_dir
  # echo ""
  echo "$1 BOOT is mounted at $boot_dir"
  echo "Type 'sudo umount $boot_dir' to unmount it"
  # echo ""
fi


if [[ "$2" == "root" ]]; then
  umount $root_dir 2&>1 > /dev/null
  mount -o loop,offset=$root_sector $1 $root_dir
  # echo ""
  echo "$1 ROOT is mounted at $root_dir"
  echo "Type 'sudo umount $root_dir' to unmount it"
  # echo ""
fi

