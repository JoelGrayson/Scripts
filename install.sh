#!/bin/bash

# ABOUT: install by running: bash -c "$(curl -L https://scriptmanager.io/install)"

BASE="$HOME/scriptmanager"

# Add to rc files
rc_string="""
# BEGIN Script Manager
export PATH=\"\$PATH:/$BASE\"
export PATH=\"\$PATH:/$BASE/_internals/exposed\"
for d in \"$BASE\"/*/; do # include all subfolders
    [[ "\$d" != "$BASE/_internals/" ]] && export PATH="\$PATH:$d" #excludes _internals folder which has internals
done
# END Script Manager
"""

if [[ "$(which $SHELL)" == '/bin/zsh' ]]; then
    echo "$rc_string" >> ~/.zshrc
else
    echo "$rc_string" >> ~/.bashrc
fi

# Create folder
mkdir "$BASE"
mkdir "$BASE/_internals" #this is 
mkdir "$BASE/_internals/exposed" #this is 
cat <<EOF > "$BASE/_internals/uninstall-sm"
#!/bin/bash

# Uninstall script manager

# Confirmation
echo -n "Are you sure you want to uninstall script manager (y/n)? "
read -r confirmation
if [[ "\$confirmation" != "y" && "\$confirmation" != "yes" ]]; then
    echo 'Exiting because you did not type "y" or "yes"'
    echo 'Script manager has not been uninstalled.'
fi

# Uninstalling because passed confirmation
rm -rf "$BASE"
echo "Please remove the script manager lines from your rc file (~/.bashrc or ~/.zshrc)."
EOF

echo "v1.0" > "$BASE/_internals/version.txt"
cat <<EOF > "$BASE/_internals/ABOUT.md"
# Script Manager
Easily manage scripts (commands) for shell sessions in MacOS.
EOF

# # Download script manager
# curl -L https://scriptmanager.io/install/sm --output "$BASE/_internals/exposed/sm"
# cp "$BASE/_internals/exposed/sm" "$BASE/_internals/exposed/scriptmanager" # sm = scriptmanager

# chmod +x "$BASE/_internals/"* #add permissions
