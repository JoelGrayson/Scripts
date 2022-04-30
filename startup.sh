#!/bin/bash

main() {
    # Script to run at the start of every shell session
    # Sources all the scripts

    base="$HOME/scripts"
    src="$base/_src"

    source "$src/scripts.sh" #enable `scripts` command


    # Everything is alias
    for folder_path in "$base"/*/; do #folder_path containing all files of a language
        # Language of folder
        folder_name=$(echo "$folder_path" | awk -F '/' '{ print $(NF-1) }') #get last in between `/`

        if [ "$folder_name" != '_src' ] && ! "$("$src/helpers/folder_empty.sh" "$folder_path")"; then #folder_path has files & ignore _src
            for file_path in "$folder_path"*; do #`*` for all items within the folder_path
                name="$("$src/helpers/name_from_path.sh" "$file_path")"

                chmod +x "$file_path"

                # Alias through sourcing
                temp_file_name="$src/helpers/aliases/tmp.sh"
                echo "#!/bin/bash
alias '$name'='$file_path' #alias name of command (filename) to absolute path
" > "$temp_file_name"
                chmod +x "$temp_file_name"
                source "$temp_file_name"
                
            done
        fi
    done
}

main "$@"
