#!/bin/bash

# TODO: allow option to select own editor

scripts() {
    default_language="sh"
    base="$HOME/scripts/"

    #* LOCAL FUNCTIONS
    help() {
        echo "__Scripts__
list
add
remove"
    }

    add() {        
        name="$1"
        language="$2"

       case "$language" in
           'sh'|'bash'|'shell') # Shell file
                mkdir -p "$base/sh" #-p so only creates dir if not already exists
                
                filename="$base/sh/$name.sh"
                echo -e "#!/bin/bash\n\n" > "$filename"
                # vim 
           ;;
           'js'|'javascript'|'node') # Node
                mkdir -p "$base/js"

                # filename="$base/js/$name.js"
           ;;
           'py'|'python'|'python3') # Python
                mkdir -p "$base/py"

                # filename="$base/py/$name.py"
           ;;
           *)
               echo "Unknown language: $language"
               exit 1
           ;;
       esac
       
    }

    remove() {
        name="$1"

        
    }
    
    #* COMMANDS DEFINED
    # Help
    [ -z "$1" ] && help #no arguments
    [ "$1" = '--help' ] && help
    [ "$1" = '--about' ] && help

    # List - scripts list
    [ "$1" = 'list' ] && list

    # Add - scripts add <name> <language>
    if [ "$1" = 'add' ]; then
        if [ "$2" != "" ]; then #<name> exists
            if [ "$3" != "" ]; then #<language> included
                add "$2" "$3"
            else #use default language
                add "$2" "$default_language"
            fi
        else
            echo -e "Please include a name.
scripts add <name>"
        fi
    fi

    # Remove - scripts remove <name>
    if [ "$1" = 'remove' ]; then
        if [ "$2" != "" ]; then
            remove "$2"
        else
            echo "Please include name of program to remove"
        fi
    fi

}
