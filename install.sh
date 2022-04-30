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
    cp scripts.sh startup.sh "$src"
    cp -R helpers "$src"
    cp -R languages "$src"

    # for f in "$src"/helpers/*; do #add permission to execute helpers
    #     chmod +x "$f"
    # done

    # Allow helpers & languages to be called
    chmod +x "$src/helpers/folder_empty.sh"
    chmod +x "$src/helpers/name_from_path.sh"
    chmod +x "$src/languages/j_create.sh"
    chmod +x "$src/languages/remove_cursor.js"

    # execute for current shell
    source "$src/scripts.sh"
    source "$src/startup.sh" 

    # Add sourcing startup to shell rc file for future sessions
    note="""
# Activate 'scripts' command
[ -d '$base' ] && [ -d '$src' ] && source '$src/scripts.sh' || return 0  #only activate if '$src' folder exists
"""

    [ -e ~/.zshrc ] && echo "$note" >> ~/.zshrc
    [ -e ~/.bashrc ] && echo "$note" >> ~/.bashrc
    [ -e ~/.cshrc ] && echo "$note" >> ~/.cshrc
    [ -e ~/.tcshrc ] && echo "$note" >> ~/.tcshrc

    echo "Successfully installed \`scripts\`"
    return 0
}

main "$@"
