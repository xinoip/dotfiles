#!/bin/bash

COLORSCRIPTS=$(dirname "$0")/colorscripts

greet_user_cowsay() {
    RANDOM_COW=$(ls /usr/share/cows/*.cow | shuf -n 1)
    GREET_USER=$(figlet -f mini "Welcome  back  $USER!")
    DATE_STR=$(date +%a\ %H:%M:%S)
    DATE_STR_RIGHT_ALIGN=$(figlet -f term -r $DATE_STR)
    echo "$GREET_USER $DATE_STR" \
        | cowsay -f $RANDOM_COW -n \
        | lolcat -r -b
}

greet_user_art() {
    GREET_STR="Welcome back $USER!"
    DATE_STR=$(date +%a\ %H:%M:%S)
    RANDOM_ART=$(ls $COLORSCRIPTS | shuf -n 1)
    $COLORSCRIPTS/$RANDOM_ART
    echo -e "$DATE_STR\n$GREET_STR" | lolcat -r -b
}

greet_fetch() {
    ufetch
}

greeters=("greet_user_cowsay" "greet_user_art" "greet_fetch")

greet() {
    local random_number=$(( RANDOM % 3 ))
    local index=$random_number
    local greeter=${greeters[$index]}
    # echo "selected greeter $index = $greeter"
    $greeter
}

greet

