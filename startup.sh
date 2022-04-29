#!/bin/bash

# Script to run at the start of every shell session
# Sources all the scripts

base="$HOME/scripts"

#* SHELL - source file if not `<DISABLED> `
if ! "$(./helpers/folder_empty.sh "$base/sh/")"; then
    for f in "$base"/sh/*; do
        name="$(./helpers/name_from_path.sh "$f")"
        [ "${name:0:11}" != "<DISABLED> " ] && source "$f" #source if not disabled
    done
fi

#* NODE - alias name of file to absolute path of file
for f in "$base"/js/*; do
    name="$(./helpers/name_from_path.sh "$f")"
    [ "${name:0:11}" != "<DISABLED> " ] && alias "$name"="$f"
done

#* PYTHON

