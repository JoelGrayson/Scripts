#!/bin/bash

main() {
    uninstall() { #actually uninstalls
        echo "Uninstalled \`scripts\`"
        unset -f scripts #remove the function
        rm -rf ~/scripts
    }

    [ "$1" = "-y" ] && uninstall && return 0 # -y to bypass confirmation

    # Confirmation
    echo -n "Are you sure you want to uninstall scripts? You will lose all your custom scripts.
(y/n) "
    read -r to_cancel

    [ "$to_cancel" != "y" ] && echo 'Canceling' && return 0

    uninstall
}

main "$@"
