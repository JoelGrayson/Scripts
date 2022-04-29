#!/bin/bash

# TODO: allow option to select own editor

scripts() {
    #* HELPER VARIABLES
    default_language="sh"
    base="$HOME/scripts"

    #* HELPER FUNCTIONS
    underline() {
        echo "\e[4m$1\e[0m" #surround with POSIX chars
    }

    #* LOCAL FUNCTIONS
    help() {
        echo "___$(underline "Scripts")___
list
add <name> <language>
remove <name>
enable <name>
disable <name>"
    }

    add() {        
        name="$1"
        language="$2"
        filename=""

        case "$language" in
            # Steps for language: create file, fill file, and edit file
            # Every folder is two characters long
            'sh'|'bash'|'shell') # Shell file
                mkdir -p "$base/sh" #-p so only creates dir if not already exists
                
                filename="$base/sh/$name.sh"
                [ -e "$filename" ] && echo "$name already exists" && return 1 #do not allow already file exists
                boilerplate="""#!/bin/bash

${name}() {
    
}
"""
                echo -e "$boilerplate" > "$filename" #create file with boiler plate code
                vim "+call cursor(4, 5)" "$filename"
            ;;
            'js'|'javascript'|'node') # Node
                mkdir -p "$base/js"

                filename="$base/js/$name.js"
                [ -e "$filename" ] && echo "$name already exists" && return 1
                echo -e "#!/usr/bin/env node\n\n\n" > "$filename"

                vim "$filename" #open in vim editor
            ;;
            'py'|'python'|'python3') # Python
                mkdir -p "$base/py"

                filename="$base/py/$name.py"
                [ -e "$filename" ] && echo "$name already exists" && return 1
                echo -e "#!/usr/bin/env python\n\n\n" > "$filename"

                vim "$filename" #open in vim editor
            ;;
            *)
                echo "Unknown language: $language"
                return 1
            ;;
        esac
        
        # apply to all files
        source "$filename"
    }

    list() {
        for folder in "$base"/*/; do #folder containing all files of a language
            if ! "$(./helpers/folder_empty.sh "$folder")"; then #folder has files
                language=$(echo "$folder" | awk -F '/' '{ print $(NF-1) }') #get last in between `/`
                echo "___$(underline "$language")___"

                for file in "$folder"*; do #`*` for all items within the folder
                    ./helpers/name_from_path.sh "$file"
                done
            fi
        done
    }

    disable() { #adds `<DISABLED> ` to start of target command
        name="$2"
        matched=false

        for folder in "$base"/*/; do
            if ! "$(./helpers/folder_empty.sh "$folder")"; then #folder has files
                for file in "$folder"*; do
                    if [ "$name" = "$(./helpers/name_from_path.sh "$file")" ] && ! $matched; then

                        new_name="${file%/*}/<DISABLED> $(./helpers/name_from_path.sh -e "$file")"
                        mv "$file" "$new_name"

                        matched=true #indicate that a command was removed
                    fi
                done
            fi
        done

        if ! $matched; then
            echo "$name script does not exist"
        fi
    }

    enable() { #removes `<DISABLED> ` from the start of the target script file
        name="$2" #target
        matched=false

        for folder in "$base"/*/; do
            if ! "$(./helpers/folder_empty.sh "$folder")"; then #folder has files
                for file in "$folder"*; do
                    filename="$(./helpers/name_from_path.sh "$file")"

                    if [ "$name" = "$filename" ] && ! $matched; then #already enabled
                        echo "$name already enabled"
                        matched=true
                    fi
                    
                    if [ "${filename:0:11}" = "<DISABLED> " ]; then #file is disabled
                        script_name="${filename:11}"

                        script_name_with_extension="$(./helpers/name_from_path.sh -e "$file")"
                        script_name_with_extension="${script_name_with_extension:11}" #remove `<DISABLED> ` from start of file

                        if [ "$script_name" = "$name" ]; then #target found
                            new_name="$folder$script_name_with_extension"
                            mv "$file" "$new_name"
                            matched=true
                        fi
                    fi
                done
            fi
        done

        if ! $matched; then
            echo "$name script does not exist"
        fi
    }

    remove() {
        name="$1"
        matched=false

        for folder in "$base"/*/; do
            if ! "$(./helpers/folder_empty "$folder")"; then #folder has files
                for file in "$folder"*; do
                    if [ "$name" = "$(./helpers/name_from_path.sh "$file")" ] && ! $matched; then

                        rm "$file";
                        if "$(./helpers/folder_empty.sh "$folder")"; then #remove folder if empty after script removed
                            rm -r "$folder"
                        fi

                        matched=true #indicate that a command was removed
                    fi
                done
            fi
        done

        if ! $matched; then
            echo "$name script does not exist"
            return 1
        fi
    }

    uninstall() {
        rm -rf "$base"
    }

    #* COMMANDS DEFINED
    called=false #check if a command was executed
    # Help
    [ -z "$1" ] || [ "$1" = '--help' ] || [ "$1" = 'help' ] || [ "$1" = '-h' ] && help && called=true

    # List - scripts list
    [ "$1" = 'list' ] || [ "$1" = 'ls' ] && list && called=true

    # Disable & enable
    [ "$1" = 'disable' ] && disable "$@" && called=true
    [ "$1" = 'enable' ] && enable "$@" && called=true

    # Uninstall
    [ "$1" = 'uninstall' ] && uninstall && called=true

    # Add - scripts add <name> <language>
    if [ "$1" = 'add' ]; then
        if [ "$2" != "" ]; then #<name> exists
            called=true
            if [ "$3" != "" ]; then #<language> included
                add "$2" "$3"
            else #use default language
                add "$2" "$default_language"
            fi
        else
            echo -e "Please include the script's name and optionally language.
scripts add <name> <language>"
            return 1
        fi
    fi

    # remove | rm - scripts rm <name> <name2> <name3> ...
    if [ "$1" = 'remove' ] || [ "$1" = "rm" ]; then
        called=true
        [ -z "$2" ] && echo "Please include name of program to remove" && return 1 #make sure arguments after 'remove'

        shift #shift over parameters to remove $1, which is "remove"
        for to_remove in "$@"; do
            remove "$to_remove"
        done
    fi

    #no commands triggered
    ! $called && echo "Invalid command" "$@" && return 1
}
