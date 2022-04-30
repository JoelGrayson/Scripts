#!/bin/bash

: ' Steps
* Create a ~/scripts folder
* Create the scripts command
* Execute startup in this shell
* Make sure startup is executed when zsh starts up
'

main() {
    base="$HOME/scripts"
    [ -d "$base" ] && echo "There is already a folder named $base. Please remove or rename it before installing scripts." && return 1

    mkdir "$base"

    # Transfer to src
    src="$base/_src"
    mkdir "$src"
    cp scripts.sh startup.sh uninstall.sh "$src"
    cp -R helpers "$src"
    cp -R languages "$src"

    # Allow helpers & languages to be called
    for f in "$src"/helpers/*; do
        chmod +x "$f"
    done
    for f in "$src"/languages/*.{sh,js}; do
        chmod +x "$f"
    done

    
    note="""
# Activate \`scripts\` command
[ -d '$base' ] && [ -d '$src' ] && source '$src/startup.sh' || return 0  #only activate if '$src' folder exists
"""
    
    eval "$note" # execute for current shell

    add_to_rc_file() {
        f="$1"
        if [ -e "$f" ]; then #file exists, so add to it
            if ! grep -q """source '$HOME/scripts/_src/startup.sh'""" ~/.zshrc; then #Only add note to script if it does not already have it
                # Does not have note, so add it
                echo "$note" >> "$f"
            fi
        fi
    }

    # Add sourcing startup to shell rc file for future sessions
    add_to_rc_file ~/.zshrc
    add_to_rc_file ~/.bashrc
    add_to_rc_file ~/.cshrc
    add_to_rc_file ~/.tcshrc

    echo "Successfully installed \`scripts\`"
    return 0
}

main "$@"
