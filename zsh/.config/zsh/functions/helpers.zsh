#!/bin/zsh

# $1 message
function pio_confirm() {
    printf "%s" "$1 (y/N) "
    read -q "REPLY?" || return 1
    printf "\n"
    [[ ! $REPLY =~ ^[Nn]$ ]]
}
