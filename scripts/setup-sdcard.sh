#!/bin/bash
#
# setup-sdcard.sh - Update files as necessary.
#
# Setup requires making the following changes to the FullPageOS image.
# - Set hostname in '/etc/hosts' and '/etc/hostname'.
# - Set the HTTP URL in '/boot/fullpageos.txt'.
# - Delete the '/home/pi/.config/chromium' folder.
# - Delete the '/boot/setup.txt' file when complete.


# Variables
FPOS_FILE="/boot/fullpageos.txt"
CHROMIUM_DIR="/home/pi/.config/chromium"
LINE_FILE="/boot/LINE.txt"
LINK_URL="http://10.0.1.89/Pages/Production/DisplayP1BonusNew.aspx?LineNo="

# Line details array (PM ID, Hostname)
    declare -A LA
    LA["L05"]="PM0021","line05-pi"
    LA["L10"]="PM0022","line10-pi"
    LA["L15"]="PM0023","line15-pi"
    LA["L20"]="PM0024","line20-pi"
    LA["L25"]="PM0025","line25-pi"
    LA["L30"]="PM0026","line30-pi"
    LA["L35"]="PM0027","line35-pi"
    LA["L40"]="PM0028","line40-pi"
    LA["L45"]="PM0029","line45-pi"
    LA["L50"]="PM0030","line50-pi"
    LA["L55"]="PM0031","line55-pi"
    LA["L60"]="PM0032","line60-pi"
    LA["L65"]="PM0033","line65-pi"


# Functions
set_hostname() {
    echo -e "Setting Hostname\n"
    if [ ${HOSTNAME} != ${NEW_HOSTNAME} ]; then
        echo -e "Updating Hostname\n"
        echo ${NEW_HOSTNAME} | sudo tee /etc/hostname
        sudo sed -i "s/127\.0\.1\.1\t${HOSTNAME}/127\.0\.1\.1\t${NEW_HOSTNAME}/g" \
            /etc/hosts
		# Sometimes there is a double tab?
        sudo sed -i "s/127\.0\.1\.1\t\t${HOSTNAME}/127\.0\.1\.1\t${NEW_HOSTNAME}/g" \
            /etc/hosts
    else
        echo -e "Hostname is correct\n"
    fi
}

# RUN
# If Setup file exists, run this script
if [ -f "$LINE_FILE" ]; then
    # Get Line details from LINE_FILE
    LINE_FILE_CAP=$(cat ${LINE_FILE})
    LINE_ID=${LINE_FILE_CAP^^}

    # Parse details
    LINE_NO=${LA[$LINE_ID]}
    PM_ID=$(echo $LINE_NO | awk -F ',' '{print $1}')
    NEW_HOSTNAME=$(echo $LINE_NO | awk -F ',' '{print $2}')
    
    # Set new Link URL
    echo "Setting Kiosk URL"
    NEW_LINK_URL=${LINK_URL}${PM_ID}
    echo $NEW_LINK_URL > $FPOS_FILE
    
    # Clear Chromium settings
    if [ -d "$CHROMIUM_DIR" ]; then
        echo "Deleting $CHROMIUM_DIR"
        rm -rf $CHROMIUM_DIR
    fi

    # Set hostname
    echo "Setting hostname"
    set_hostname

    # Complete
    echo "Done. Reboot RPI to start kiosk."
    echo "NOTE: RPI may reboot a couple times to complete the setup."
fi