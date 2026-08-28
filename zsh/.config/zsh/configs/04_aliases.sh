#!/usr/bin/env bash

setup() {
    # Core utils
    alias cat='bat --pager=never --theme=ansi --style=plain'
    alias catf='bat --theme=ansi'
    alias ls='lsd --group-dirs first'
    alias la='ls -lAh'
    alias tree='lsd --tree'
    alias vim='nvim'
    alias clearf="/usr/bin/clear"
    alias clear="clear && pio_greet"
    alias sudo='sudo '

    # Programs
    alias lg='echo "foo" | gpg --sign > /dev/null; lazygit'
    alias lzd='lazydocker'
    alias lf='yzcd'
    alias du='dust'
    alias df='duf'
    alias ip='ip -c'
    alias ipb='ip -brief'
    alias tlist="tmux list-sessions"
    alias tm="tmux new-session -A -s main"
    alias ta="tmux attach -t"

    # Safe delete
    alias del='trash'
    alias delf=" $(which rm) -rf"
    alias rm="echo 'use del'"

    # Git
    alias gpush='git push'
    alias gpull='git pull'
    alias greset="git reset --hard @{u}"
    alias gs="git status -sb"
    alias gc="git commit -v"
    alias gb="git branch"
    alias gblog="git branch -al"
    alias glog="git log --oneline --decorate --graph"
    alias gcheck="git checkout"
    alias gcreate="git checkout -b"
    alias gfetch="git fetch --all --tags"
    alias gprune="git remote prune origin"
    alias gbump="git commit --allow-empty -m 'bump' --no-verify"
    alias ga="git add"
    alias gr="git remote"
    alias gac='git add -A && git commit -m "auto: $(date)"'

    # Misc
    alias pio_copy='xclip -selection clipboard'
    alias kimg="kitty +kitten icat"
    alias history='fc -li 1'
    alias pio_logout="sudo pkill -u pio"

    # Ubuntu
    if [[ "$PIOBUNTU" == true ]]; then
        alias bat=batcat
        alias xi="sudo apt-get install"
        alias xrm="sudo apt-get autoremove"
    fi

    # Void
    alias void_python_setup="python3 -m venv ~/3pp/python-env"
    alias void_python_activate=". ~/3pp/python-env/bin/activate"
    alias void_python_pip="~/3pp/python-env/bin/pip"
}

setup
unset -f setup
