#!/bin/bash

# Create images using companion scripts

BASE_IMG="line00-pi.img"

LINE_NAMES=(
    line05 line10 line15 line20 
    line25 line30 line35 line40 
    line45 line50 line55 line60 
    line65
    )

declare -A LINE_PMS
LINE_PMS["line05"]="pm0021"
LINE_PMS["line10"]="pm0022"
LINE_PMS["line15"]="pm0023"
LINE_PMS["line20"]="pm0024"
LINE_PMS["line25"]="pm0025"
LINE_PMS["line30"]="pm0026"
LINE_PMS["line35"]="pm0027"
LINE_PMS["line40"]="pm0028"
LINE_PMS["line45"]="pm0029"
LINE_PMS["line50"]="pm0030"
LINE_PMS["line55"]="pm0031"
LINE_PMS["line60"]="pm0032"
LINE_PMS["line65"]="pm0033"


# Functions
check_root() {
    if [ $(id -u) -ne 0 ]; then
        echo "\nInstaller must be run as root."
        echo "Try 'sudo bash $0'"
        exit 1
    fi
}

build_image() {
    for i in "${LINE_NAMES[@]}"; do
        LINE_NAME="$i"
        HOST_NAME="$LINE_NAME-pi"
        IMAGE_FILE="$LINE_NAME-pi.img"
        PM_ID=${LINE_PMS[$i]}
        echo "Building image for $i"
        echo "Hostname=$HOST_NAME : Image File=$IMAGE_FILE : PM ID=$PM_ID"
        echo "Copying $BASE_IMG to $IMAGE_FILE"
        cp $BASE_IMG $IMAGE_FILE
        if ! [ -f $IMAGE_FILE ]; then
            echo "$IMAGE_FILE not found. Exiting."
            exit 1
        fi
        
        echo "Updating $IMAGE_FILE"
        /usr/local/bin/update_img_file.sh $IMAGE_FILE $HOST_NAME $PM_ID
        
        echo "Compressing $IMAGE_FILE to $IMAGE_FILE.zip"
        pigz -K $IMAGE_FILE
        echo "Done"
    done
}


# Run
check_root
build_image
