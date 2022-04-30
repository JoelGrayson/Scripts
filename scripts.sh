#!/bin/bash

# TODO: allow option to select own editor

scripts() {
    #* HELPER VARIABLES
    default_language="sh"
    base="$HOME/scripts"
    src="$base/_src"

    #* HELPER FUNCTIONS
    underline() { #str -> ___s_t_r___ (underline and surround with ___)
        echo "___\e[4m$1\e[0m___" #surround with POSIX chars
    }

    #* LOCAL FUNCTIONS
    help() {
        echo "$(underline "Scripts")
Usage: scripts <command>

Commands:
   list                    Show all commands
   add <name> <language>   Create your own command
   remove <name>           Remove a command
   edit <name>             Edit your command
   enable <name>           Enable a disabled command
   disable <name>          Temporarily disable a command
   languages               Shows all available languages
   languages add <name>    Add configuration for another language (in .j file)
   version                 Show version when installed
"
    }

    add() {        
        name="$1"
        language="$2"

        mkdir -p "$base/$language" #-p so only creates dir if not already exists
        
        filename="$base/$language/$name" #no file extension for simplicity
        [ -e "$filename" ] && echo "$name already exists" && return 1 #do not allow already file exists
        
        "$src/languages/j_create.sh" "$filename" "$language" "$name"

        source "$filename" #temporarily source for current session
    }

    edit() {
        echo PASS
    }

    list() {
        for folder_path in "$base"/*/; do #folder_path containing all files of a language
            # Language of folder
            folder_name=$(echo "$folder_path" | awk -F '/' '{ print $(NF-1) }') #get last in between `/`

            if [ "$folder_name" != '_src' ] && ! "$("$src/helpers/folder_empty.sh" "$folder_path")"; then #folder_path has files & ignore _src
                underline "$folder_name"

                for file in "$folder_path"*; do #`*` for all items within the folder_path
                    "$src/helpers/name_from_path.sh" "$file"
                done
            fi
        done
    }

    disable() { #adds `<DISABLED> ` to start of target command
        name="$2"
        matched=false

        for folder in "$base"/*/; do
            if ! "$("$src/helpers/folder_empty.sh" "$folder")"; then #folder has files
                for file in "$folder"*; do
                    if [ "$name" = "$("$src/helpers/name_from_path.sh" "$file")" ] && ! $matched; then

                        new_name="${file%/*}/<DISABLED> $("$src/helpers/name_from_path.sh" -e "$file")"
                        mv "$file" "$new_name"

                        matched=true #indicate that a command was removed

                        temp_file_name="$src/helpers/aliases/tmp.sh"
                        echo "#!/bin/bash
unalias $name" > "$temp_file_name"
                        chmod +x "$temp_file_name"
                        source "$temp_file_name" #temporarily removes the command from session
                    fi
                done
            fi
        done

        ! $matched && "$name script does not exist"
    }

    enable() { #removes `<DISABLED> ` from the start of the target script file
        name="$2" #target
        matched=false

        for folder in "$base"/*/; do
            if ! "$("$src/helpers/folder_empty.sh" "$folder")"; then #folder has files
                for file in "$folder"*; do
                    filename="$("$src/helpers/name_from_path.sh" "$file")"

                    if [ "$name" = "$filename" ] && ! $matched; then #already enabled
                        echo "$name already enabled"
                        matched=true
                    fi
                    
                    if [ "${filename:0:11}" = "<DISABLED> " ]; then #file is disabled
                        script_name="${filename:11}"

                        script_name_with_extension="$("$src/helpers/name_from_path.sh" -e "$file")"
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
            if ! "$("$src/helpers/folder_empty.sh" "$folder")"; then #folder has files
                for file in "$folder"*; do
                    if [ "$name" = "$("$src/helpers/name_from_path.sh" "$file")" ] && ! $matched; then

                        rm "$file";
                        if "$("$src/helpers/folder_empty.sh" "$folder")"; then #remove folder if empty after script removed
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

    # Language support
    list_languages() {
        underline Languages
        for f in "$src"/languages/templates/*.j; do
            echo "${f%*.j}" | awk -F '/' '{print $NF}'
        done
    }

    add_language() {
        name="$1"
        filename="$src/languages/templates/$name.j"
        touch "$filename"
        vim "$filename"
    }

    remove_language() {
        name="$1"
        filename="$src/languages/templates/$name.j"
        [ -e "$filename" ] && rm "$filename" && echo "Removed $name.j" || echo "$name.j does not exist in $src/languages/templates/"
    }

    version() {
        echo "v1.0.0"
    }

    #* COMMANDS DEFINED
    called=false #check if a command was executed
    # Help
    [ -z "$1" ] || [ "$1" = '--help' ] || [ "$1" = 'help' ] || [ "$1" = '-h' ] && called=true && help

    # List - scripts list
    [ "$1" = 'list' ] || [ "$1" = 'ls' ] && called=true && list

    # Edit
    [ "$1" = 'edit' ] && shift && edit "$@"

    # Disable & enable
    [ "$1" = 'disable' ] && called=true && shift && disable "$@"
    [ "$1" = 'enable' ] && called=true && shift && enable "$@"

    # Languages
    if [ "$1" = 'languages' ]; then
        [ -z "$2" ] || [ "$2" = 'list' ] || [ "$2" = 'ls' ] && called=true && list_languages
        [ "$2" = 'add' ] && [ "$3" != '' ] && called=true && shift 2 && add_language "$@"
        [ "$2" = 'remove' ] || [ "$2" = 'rm' ] && [ "$3" != '' ] && called=true && shift 2 && remove_language "$@"
        
        # Invalid usage of languages
        ! $called && echo "Usage: scripts languages <command>

$(underline Commands)
list           Shows all available languages
add <name>     Add configuration for another language (in .j file)
remove <name>  Removes support for a language
" && return 1 || return 0
    fi


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

    # Version
    [ "$1" = 'version' ] || [ "$1" = '-v' ] && called=true && version



    #no commands triggered
    ! $called && echo "Invalid command" "$@" && return 1 || return 0
}
