#!/bin/bash

# Shortcut to compress all files
# Only works with files in the current directory
# Uses pigz

PIGZ=$(which pigz)

if [[ -z "$PIGZ" ]]; then
    echo "pigz not found. Installing."
    sudo apt install pigz -y
fi

for f in *.img; do
    echo -n "Compressing $f..."
    pigz -kK $f
    echo "Done"
done
