#!/usr/bin/env bash

# Callback for changing directories.
chpwd() {
    ls
}

# Make yazi change directory on exit.
yzcd() {
    local tmp
    tmp="$(mktemp -t "yazi-cwd.XXXXXX")"

    yazi "$@" --cwd-file="$tmp"
    if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
        cd -- "$cwd" || return
    fi
    delf -- "$tmp"
}
