#!/bin/zsh

export EDITOR='nvim'
export VISUAL='nvim'
export MANPAGER='nvim +Man!'
export MANWIDTH=999
export LANG='en_US.UTF-8'
export LC_CTYPE='en_US.UTF-8'
export LC_ALL='en_US.UTF-8'

if $PIOBUNTU; then
    export PAGER=''
else
    export PAGER='bat'
fi

# Determine if we are running on Ub*ntu
export PIOBUNTU=false
if [[ -f /etc/lsb-release ]]; then
    if grep -q "Ubuntu" /etc/lsb-release; then
        PIOBUNTU=true
    fi
fi
