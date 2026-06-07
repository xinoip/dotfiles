#!/bin/zsh

pio_confirm() {
    local -r MSG="$1"
    read -q "?$MSG (y/N) "
    local ok=$?
    printf "\n"
    return $ok
}
