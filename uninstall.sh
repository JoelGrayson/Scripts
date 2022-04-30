#!/bin/bash

main() {
    echo 'Are you sure you want to uninstall scripts? (y/n)'
    read -r to_cancel

    [ "$to_cancel" != "y" ] && echo 'Cancelling' && return

    echo "Uninstalled \`scripts\`"
    alias scripts="" #temporarily uninstall scripts for this session
    rm -rf ~/scripts
}

main "$@"
