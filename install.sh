#!/bin/bash

: ' Steps
* Create a ~/scripts folder
* Create the scripts command
* Execute startup in this shell
* Make sure startup is executed when zsh starts up
'

main() {
    base="$HOME/scripts"
    [ -d "$base" ] && echo "There is already a folder named $base. Please remove or rename it before installing scripts" && return 1

    mkdir "$base"

    # Transfer to src
    mkdir "$src"
    src="$base/_src"
    cp scripts.sh startup.sh helpers "$src"

    # execute for current shell
    source "$src/scripts.sh"
    source "$src/startup.sh" 

    # Add sourcing startup to rc file for future sessions
    case "$(echo "$0")" in #support for different shells
        zsh|/usr/local/bin/zsh) echo "source '$src/scripts.sh'" >> ~/.zshrc ;;
        bash) echo "source '$src/startup.sh'" >> ~/.bashrc ;;
        csh) echo "source '$src/startup.sh'" >> ~/.cshrc ;;
        tcsh) echo "source '$src/startup.sh'" >> ~/.tcshrc ;;
        dash) echo "source '$src/startup.sh'" >> ~/.profile ;;
        sh) echo "source '$src/startup.sh'" >> ~/.profile ;;
        *) echo "Unknown shell. This only supports zsh, bash, and fish."
    esac
    
}

main "$@"