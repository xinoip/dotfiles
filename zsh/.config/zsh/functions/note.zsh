#!/bin/zsh

function note() {
    local note_file="$HOME/tmp/note_$(date +%Y%m%d%H%M%S).md"
    $EDITOR "$note_file"
}
