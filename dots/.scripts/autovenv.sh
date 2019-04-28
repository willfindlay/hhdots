#!/bin/bash
# autovenv.sh
#
# Original script created by: Cody Soyland    https://gist.github.com/codysoyland
# Better version by:          William Findlay https://github.com/housedhorse
#
# Installation:
#   Add this line to your .bashrc or .bash-profile:
#
#       source /path/to/virtualenv-auto-activate.sh
#
#   Go to your project folder, run "virtualenv .venv", so your project folder
#   has a .venv folder at the top level, next to your version control directory.
#   For example:
#   .
#   ├── .git
#   │   ├── HEAD
#   │   ├── config
#   │   ├── description
#   │   ├── hooks
#   │   ├── info
#   │   ├── objects
#   │   └── refs
#   └── .venv
#       ├── bin
#       ├── include
#       └── lib
#
#   The virtualenv will be activated automatically when you enter the directory.
_virtualenv_auto_activate() {
    if [ -z "$_VENV_ACTIVATED" ]; then
        _VENV_ACTIVATED=false
    fi
    if [ -e ".venv" ]; then
        # Check to see if already activated to avoid redundant activating
        if [ "$VIRTUAL_ENV" != "$(pwd -P)/.venv" ]; then
            # only execute if .venv is owned by user and has safe permissions
            if [ "$(stat -c "%a %u" .venv)" = "$(echo 755 $(id -u))" ]; then
                _VENV_NAME=$(basename `pwd`)
                # activate venv and set remember that it is active
                source .venv/bin/activate && _VENV_ACTIVATED=true
            fi
        fi
    else
        # deactivate the venv if we cd out
        if $_VENV_ACTIVATED; then
            deactivate && _VENV_ACTIVATED=false
        fi
    fi
}

export PROMPT_COMMAND="_virtualenv_auto_activate && $PROMPT_COMMAND"
