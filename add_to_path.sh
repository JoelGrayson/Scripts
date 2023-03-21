#!/bin/bash

echo "Add this to ~/.bashrc:"
echo "# J_Scripts"
echo -n 'export PATH="$PATH'
for d in */; do
    export PATH="$PATH:/Users/joelgrayson/scripts/$d"
    echo -n ":$(pwd)/$d"

    # Add permissions
    for f in $d/*; do
        chmod +x "$f"
    done
done
echo '"'
