#!/bin/bash

main() {
    # Script to run at the start of every shell session
    # Sources all the scripts

    base="$HOME/scripts"
    src="$base/_src"

    #* SHELL - source file if not `<DISABLED> `
    if [ -d "$base/sh" ]; then #directory exists
        if ! "$("$src/helpers/folder_empty.sh" "$base/sh/")"; then #directory not empty
            for f in "$base"/sh/*; do #loop through directory
                name="$(./helpers/name_from_path.sh "$f")"
                [ "${name:0:11}" != "<DISABLED> " ] && source "$f" #source if not disabled
            done
        fi
    fi

    #* NODE - alias name of file to absolute path of file
    if [ -d "$base/js" ]; then #directory exists
        if ! "$("$src/helpers/folder_empty.sh" "$base/js/")"; then
            for f in "$base"/js/*; do
                name="$("$src/helpers/name_from_path.sh" "$f")"
                [ "${name:0:11}" != "<DISABLED> " ] && alias "$name"="$f"
            done
        fi
    fi

    #* PYTHON
}

main "$@"
