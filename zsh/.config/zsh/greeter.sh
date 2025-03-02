#!/bin/bash

COLORSCRIPTS=$(dirname "$0")/colorscripts

greet_user_cowsay() {
    RANDOM_COW=$(ls /usr/share/cows/*.cow | shuf -n 1)
    GREET_USER=$(figlet -f mini "Welcome  back  $USER!")
    DATE_STR=$(date +%a\ %H:%M:%S)
    DATE_STR_RIGHT_ALIGN=$(figlet -f term -r $DATE_STR)
    echo "$GREET_USER $DATE_STR" |
        cowsay -f $RANDOM_COW -n |
        lolcat
}

greet_user_art() {
    GREET_STR="Welcome back $USER!"
    DATE_STR=$(date +%a\ %H:%M:%S)
    # ls only the files, excludes folder 'disabled'
    RANDOM_ART=$(ls -p $COLORSCRIPTS | grep -v / | shuf -n 1)
    $COLORSCRIPTS/$RANDOM_ART
    echo -e "$DATE_STR ($RANDOM_ART)\n$GREET_STR" | lolcat
}

greet_fetch() {
    # local fetchers=("ufetch" "fastfetch")
    # local index=$(( RANDOM % 2 ))
    # local fetch=${fetchers[$index]}
    # $fetch
    ufetch
    GREET_STR="Welcome back $USER!"
    DATE_STR=$(date +%a\ %H:%M:%S)
    echo -e "$DATE_STR\n$GREET_STR" | lolcat
}

greet() {
    local greeters=("greet_fetch" "greet_user_art")
    local random_number=$((RANDOM % 2))
    local index=$random_number
    local greeter=${greeters[$index]}
    # echo "selected greeter $index = $greeter"
    $greeter
}

greet
