# Installation
source install.sh


# Commands
scripts list
scripts add <name> <language>
scripts remove <name>
scripts has <name>
scripts disable <name>
scripts enable <name>
scripts edit <name>


<language> - sh (bash), zsh, js (node), py (python3)

scripts disable <name>
    Renames `script.sh` to `<disabled> script.sh`
scripts enable <name>
    Renames `<disabled> script.sh` to `script.sh`

scripts get <var>
scripts set <var> <new value>

### Config Values
* editor - path to editor
* default_language

