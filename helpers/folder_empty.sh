#!/bin/bash

folder="$1"

if [ -z "$(ls "$folder")" ]; then
    echo true
else
    echo false
fi
