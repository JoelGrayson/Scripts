# BEGIN Scripts
export PATH="$PATH:/$BASE"
export PATH="$PATH:/$BASE/_internals/exposed"
for d in "$BASE"/*/; do # include all subfolders
    [[ "$d" != "$BASE/_internals/" ]] && export PATH="$PATH:$d" #excludes _internals folder
done
# END Scripts