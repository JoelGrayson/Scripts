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
###import-file: scripts
EOF
cp "$BASE/_internals/exposed/scripts" "$BASE/_internals/exposed/s" # `scripts` can be abbreviated to `s`


# Uninstall-Scripts
cat <<EOF > "$BASE/_internals/exposed/uninstall-scripts"
###import-file: uninstall-scripts
EOF

echo "v1.0" > "$BASE/_internals/version.txt"
cat <<EOF > "$BASE/_internals/ABOUT.md"
###import-file: ABOUT.md
EOF

# Templates
mkdir "$BASE/_internals/templates"
###insert-templates


# ? Is this necessary? ↓
# chmod +x "$BASE/_internals/exposed/"* #make sure exposed are executable

