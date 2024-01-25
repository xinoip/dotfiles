#!/bin/bash

greet_user_cowsay() {
    RANDOM_COW=$(ls /usr/share/cows/*.cow | shuf -n 1)
    GREET_USER=$(figlet -f mini "Welcome  back  $USER!")
    DATE_STR=$(date +%a\ %H:%M:%S)
    DATE_STR_RIGHT_ALIGN=$(figlet -f term -r $DATE_STR)
    echo "$GREET_USER $DATE_STR_RIGHT_ALIGN" \
        | cowsay -f $RANDOM_COW -W80 -n \
        | lolcat -r -b
}

greet_user_art() {
    GREET_STR="Welcome back $USER!"
    DATE_STR=$(date +%a\ %H:%M:%S)
    RANDOM_ART=$(ls $HOME/3pp/colorscripts | shuf -n 1)
    $HOME/3pp/colorscripts/$RANDOM_ART
    echo -e "$DATE_STR\n$GREET_STR" | lolcat -r -b
}

random_number=$((1 + $RANDOM % 100))
if [ "$random_number" -le "40" ]; then
    greet_user_cowsay;
else
    greet_user_art;
fi

