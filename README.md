# Script Manager
Easily manage scripts (commands) for shell sessions in MacOS.

## Installation
```bash
bash -c "$(curl -L http://scriptmanager.io/install.sh)"
```


## Documentation
sm list
sm add <name> <language>
sm remove <name>
sm has <name>
sm disable <name>
sm enable <name>
sm edit <name>

sm disable <name>
    Renames `script.sh` to `<disabled> script.sh`
sm enable <name>
    Renames `<disabled> script.sh` to `script.sh`

sm get <var>
sm set <var> <new value>

## Config Values
* editor - path to editor
    * vim
    * vscode
    * sublime
* default_language
