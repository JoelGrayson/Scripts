#!/bin/bash

main() {
    [ -z "$1" ] || [ "$1" = 'help' ] && echo "j_create <filename> <language> <script name>" && return #no arguments
    
    filename="$1"
    language="$2"
    name="$3" #used for preprocessing with `eval`

    raw_boilerplate="$(cat "./templates/${language}.j")"
    # Expand variables in .j file such as ${name}
    boilerplate="$(eval """echo \"$raw_boilerplate\"""")" #processed boilerplate

    # Find place
    echo "$boilerplate" > temp
    place="$(find_cursor ./temp)"
    rm temp

    # Remove {{CURSOR}} for real file
    ./remove_cursor.js "$boilerplate" > "$filename" #create file with boiler plate code

    echo "Place: $place"
    vim "+call cursor$place" "$filename"
}

find_cursor() { # Finds the position of {{CURSOR}}
    buff="$(grep -n -m 1 '{{CURSOR}}' "$1")"
    buff2="$(echo "$buff" | awk '{print $1}')"
    line_number="${buff2%:}" #line number of cursor
    
    # Line at line number
    line="$(awk '{ if (NR=='"$line_number"') print $0 }' < "$1")"
    char_number=0

    for ((i=0; i<${#line}; i++)); do
        if [ "${line:$i:10}" = '{{CURSOR}}' ]; then #next 10 characters from char position are {{CURSOR}}
            char_number=$((i+1)) #account for one-indexed -> zero-indexed
            break
        fi
    done

    echo "($line_number, $char_number)"
}

main "$@"
