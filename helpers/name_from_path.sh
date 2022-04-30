#!/bin/bash

#echos the command from the file path

# Eg: name_from_path /Users/joelgrayson/scripts/py/script.py -> script
# Eg: name_from_path -e /Users/joelgrayson/scripts/py/script.py -> script.py

u_path="${@: -1}" #last argument; path variable is already taken
remove_extension=true

while getopts ':e' opt; do
    case "$opt" in
        e) remove_extension=false ;; #preserve file extension
        *) echo "Usage: -e for including file extension"
    esac
done

echo $u_path
filename="$(echo "$u_path" | awk -F '/' '{ print $NF }')" #only last item

$remove_extension && echo "${filename%.*}" || echo "$filename" #remove file extension if any

