#!/bin/zsh

function pio_serve() {
    if [ -n "$1" ]; then
        python3 -m http.server $1
    else
        python3 -m http.server 3000
    fi
}
