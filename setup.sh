#!/bin/bash

here="func/v-install-wp"
there="/usr/local/sbin/v-install-wp"

if [ -z $VESTA ]; then VESTA=/usr/local/vesta; fi
if [ ! -e $VESTA ]; then echo "Vesta not installed."; exit; fi

if [ $(whoami) != "root" ]; then
    echo "Permission denied."
    exit
fi

if [ "$1" == "--remove" ]; then
    if [ -e $there ]; then
        rm -rf $there
    fi
    echo "Removed."
    exit
fi

cp $here $there
echo "Installed."
echo "Run 'v-install-wp --help' more info."
