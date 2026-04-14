#!/bin/zsh

function pio_greet_user_art() {
    local colorscripts=~/.config/zsh/assets/colorscripts
    local random_art=$(/usr/bin/ls -p "$colorscripts" | grep -v / | shuf -n 1)
    "$colorscripts"/"$random_art"
}

function pio_greet_fetch() {
    ufetch
}

function pio_greet_pokemon() {
    ~/.config/zsh/assets/pokemon-colorscripts/pokemon-colorscripts -r --no-title -s
}

function pio_greet() {
    local greeters=("pio_greet_fetch" "pio_greet_user_art" "pio_greet_pokemon")
    local index=$(((RANDOM % ${#greeters[@]}) + 1))
    local greeter=${greeters[$index]}
    # echo "index: $index greeter: $greeter"
    $greeter
}
