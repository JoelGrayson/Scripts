#!/bin/bash

# ABOUT: install by running: bash -c "$(curl -L https://scripts.so/install)"

BASE="$HOME/scripts"

# # Add to rc files
#region
rc_string="""
# BEGIN Scripts
export PATH=\"\$PATH:/$BASE\"
export PATH=\"\$PATH:/$BASE/_internals/exposed\"
for d in \"$BASE\"/*/; do # include all subfolders
    [[ \"\$d\" != \"$BASE/_internals/\" ]] && export PATH=\"\$PATH:$d\" #excludes _internals folder
done
# END Scripts
"""

if [[ ! -f ~/.zshrc ]]; then
    echo "$rc_string" >> ~/.zshrc
    echo "Added line to ~/.zshrc"
else
    echo "$rc_string" >> ~/.bashrc
    echo "Added line to ~/.bashrc"
fi
#endregion

# BASE folder
#region
mkdir "$BASE"
mkdir "$BASE/_internals"
# ## Exposed Folder
mkdir "$BASE/_internals/exposed" #this is the folder included in the $PATH including the `scripts` and `uninstall-scripts` executables

# Scripts
cat <<EOF > "$BASE/_internals/exposed/scripts"
#!/bin/bash

BASE="$HOME/scripts"

get_command_name() {
    # Get commandName from user
    commandName="$1"
    if [[ -z "$commandName" ]]; then
        echo -n 'Command name: '
        read -r commandName
    fi
    [[ -z "$commandName" ]] && exit 1
    filename="$BASE/$commandName"
}

if [[ -z $1 || $1 == 'help' || $1 == '-h' || $1 == '--help' ]]; then #list operations
    echo '___Operations___'
    echo 'scripts new {command name (cmd)}'
    echo 'scripts edit {cmd}'
    echo 'scripts delete {cmd}'
    echo 'scripts list'
    echo 'scripts download {cmd}'
    echo 'scripts publish {cmd}'
    echo
    echo 'You can include folders in the command names.'

elif [[ "$1" == "new" || "$1" == "n" ]]; then
    get_command_name "$2"
    # template="$3"

    touch "$filename"
    # Add boilerplate code
    [[ -z "$(cat $filename)" ]] || { echo "The command already exists."; exit 1; }
    printf '#!/bin/bash\n\n\n' > "$filename"
    echo "$filename has been created"
    vim "+call cursor(2, 0)" "$filename"
    chmod +x "$filename"

elif [[ "$1" == "edit" || "$1" == "e" ]]; then
    get_command_name "$2" 
    vim "$filename"
    echo "Edited $commandName"

elif [[ "$1" == "delete" || "$1" == "rm" || "$1" == "del" || "$1" == "d" ]]; then
    get_command_name "$2"
    rm "$filename"
    echo "Deleted $commandName"

elif [[ "$1" == "list" || "$1" == "ls" || "$1" == "l" ]]; then
    ls -p "$BASE" | grep -v /
    for d in "$BASE"/*/; do # include all subfolders
        [[ "$d" != "$BASE/_internals/" ]] && echo "___${d}___" && ls "$d"
    done
else
    echo "Unknown command $1"
fi

EOF
cp "$BASE/_internals/exposed/scripts" "$BASE/_internals/exposed/s" # `scripts` can be abbreviated to `s`


# Uninstall-Scripts
cat <<EOF > "$BASE/_internals/exposed/uninstall-scripts"
#!/bin/bash

# Uninstall scripts

# Confirmation
echo -n "Are you sure you want to uninstall scripts (y/n)? "
read -r confirmation
if [[ "\$confirmation" != "y" && "\$confirmation" != "yes" ]]; then
    echo 'Exiting because you did not type "y" or "yes"'
    echo 'Scripts has not been uninstalled.'
    exit 1
else
    echo "Uninstalling scripts..."
    rm -rf "$HOME/scripts"
    echo "Please remove the scripts lines from your rc file (~/.bashrc or ~/.zshrc)."
fi

EOF

echo "v1.0" > "$BASE/_internals/version.txt"
cat <<EOF > "$BASE/_internals/ABOUT.md"
# Script
Easily manage scripts (commands) for shell sessions in MacOS.
EOF

# Templates
mkdir "$BASE/_internals/templates"
{{templates}}

# ? Is this necessary? ↓
# chmod +x "$BASE/_internals/exposed/"* #make sure exposed are executable

