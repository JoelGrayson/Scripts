#!/bin/bash

base="$HOME/scripts"
src="$base/_src"

main() {
    uninstall() { #actually uninstalls
        echo "Uninstalled \`scripts\`"
        source "$src/helpers/aliases/remove_scripts.sh"
        rm -rf ~/scripts
    }

    [ "$1" = "-y" ] && uninstall && return 0 # -y to bypass confirmation

    # Confirmation
    echo -n "Are you sure you want to uninstall scripts?
(y/n) "
    read -r to_cancel

    [ "$to_cancel" != "y" ] && echo 'Canceling' && return 0

    uninstall
}

main "$@"
