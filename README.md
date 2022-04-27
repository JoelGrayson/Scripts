# Installation
Download from a source and run such as:
```sh
curl 'https://www.joelgrayson.com/scripts/scripts.sh' | bash
```
or
```sh
brew install scripts
```


# Commands
scripts list
scripts add <name> <language>
scripts has <name>
scripts remove <name>

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

