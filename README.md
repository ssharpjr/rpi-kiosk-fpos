# Raspberry Pi Kiosk Notes

## SD Card Image Setup

IMAGE: FullPageOS image from RPI Imager  

Update the following files:
- /boot/fullpageos.txt
  - Set the webpage
- /etc/hosts
  - Change the hostname
- /etc/hostname
  - Change the hostname
- Delete the /home/pi/.config/chromium folder if exists

Add the CRON file to reboot on Chromium failure.
