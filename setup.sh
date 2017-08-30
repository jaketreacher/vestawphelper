#!/bin/bash

if [ "$1" == "--remove" ]; then
    /bin/bash ./util/installer.sh --remove v-install-wp
    /bin/bash ./util/installer.sh --remove v-remove-wp
    exit 0
fi

/bin/bash ./util/installer.sh core/wp_install.sh v-install-wp
/bin/bash ./util/installer.sh core/wp_remove.sh v-remove-wp