#########################
# Core Configuration
#########################

export EDITOR='nvim'
export VISUAL='nvim'
export PAGER='bat'
export MANPAGER='nvim +Man!'
export MANWIDTH=999
export LANG='en_US.UTF-8'
export LC_CTYPE='en_US.UTF-8'
export LC_ALL='en_US.UTF-8'

eval "$(dircolors ~/.config/zsh/.dircolors)"

#########################
# SSH Agent Configuration
#########################

source ~/.config/zsh/ssh.zsh

#########################
# Programming Configuration
#########################

# Go
export GOPATH="$HOME/3pp/gopath"
# Rust
export CARGO_HOME="$HOME/3pp/cargo"
# Node
NPM_PACKAGES="$HOME/.local/npm-global"
export MANPATH="${MANPATH-$(manpath)}:$NPM_PACKAGES/share/man"
export N_PREFIX="$HOME/3pp/node"
export NEXT_TELEMETRY_DISABLED=1
export PNPM_HOME="$HOME/.local/share/pnpm"
# Flutter
export ANDROID_HOME="$HOME/3pp/android"
export ANDROID_SDK_ROOT="$ANDROID_HOME"
export FLUTTER_ROOT="$HOME/3pp/flutter"

path+=(
    "$HOME/3pp/bin"
    "$HOME/3pp/nvim/bin"
    "$HOME/.local/bin"
    "$HOME/3pp/cargo/bin"
    "$GOPATH/bin"
    "$NPM_PACKAGES/bin"
    "$HOME/stl/prefix"
    "$N_PREFIX/bin"
    "/usr/local/go/bin"
    "$PNPM_HOME"
    "$HOME/3pp/flutter/bin"
    # "$HOME/3pp/android"
    # "$HOME/3pp/android/platform-tools"
    # "$HOME/3pp/android/cmdline-tools/latest/bin"
    # "$HOME/.pub-cache/bin"
)

#########################
# Miscellaneous Configuration
#########################

export SUDO_PROMPT=$'\u001B[1m\u001B[47m\u001B[31m[sudo]\u001B[39m\u001B[49m\u001B[22m password for \u001B[1m\u001B[100m\u001B[33m%u@%h\u001B[39m\u001B[49m\u001B[22m: '
export WGETRC="~/.config/wget/.wgetrc"

#########################
# Aliases
#########################

# Make aliases available for sudo
alias sudo='sudo '
alias pio_copy='xclip -selection clipboard'
alias cat='bat --pager=never --theme=ansi --style=plain'
alias catf='bat --theme=ansi'
alias ls='lsd --group-dirs first'
alias la='ls -lAh'
alias tree='lsd --tree'
alias vim='nvim'
alias del='trash'
alias delf='/usr/bin/rm -rf'
alias rm="echo 'use del'"
alias kimg="kitty +kitten icat"
alias clearf="/usr/bin/clear"
alias clear="clear && ~/.config/zsh/greeter.sh"
alias lg='lazygit'
alias lzd='lazydocker'
alias lf='yzcd'
alias du='dust'
alias df='duf'
alias ip='ip -c'

# Git aliases
alias gpush='git push -u origin $(git rev-parse --abbrev-ref HEAD)'
alias gpull='git pull origin $(git rev-parse --abbrev-ref HEAD)'
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

# Void aliases
alias enable_ssh="sudo ln -s /etc/sv/sshd /var/service"
alias disable_ssh="sudo rm -rf /var/service/sshd"
alias xrm="sudo xbps-remove -ROo"
alias vpn_up="sudo wg-quick up /etc/wireguard/active.conf"
alias vpn_down="sudo wg-quick down /etc/wireguard/active.conf"
alias vpn_fix="sudo chown root:root -R /etc/wireguard && sudo chmod 600 -R /etc/wireguard"

# Other aliases
alias python_venv_setup="python3 -m venv ~/3pp/python-env"
alias python_venv_activate=". ~/3pp/python-env/bin/activate"
alias python_venv_pip="~/3pp/python-env/bin/pip"
alias pio_logout="sudo pkill -u pio"

#########################
# Plugin Configuration
#########################

export WD_CONFIG=~/.cache/.warprc

if [ ! -d ~/3pp/antidote ]; then
    git clone --depth=1 https://github.com/mattmc3/antidote.git ~/3pp/antidote || (echo "Antidote failed to clone" && exit 1)
fi
source ~/3pp/antidote/antidote.zsh
antidote load ~/.config/zsh/.zsh_plugins.txt

setopt share_history

autoload -Uz edit-command-line
zle -N edit-command-line
bindkey '^X^E' edit-command-line

#########################
# Theme
#########################

[[ ! -f ~/.config/zsh/.p10k.zsh ]] || source ~/.config/zsh/.p10k.zsh
~/.config/zsh/greeter.sh

##########################
# cd/ls/yazi Setup
##########################

chpwd() {
    ls
}

yzcd () {
    local tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
    yazi "$@" --cwd-file="$tmp"
    if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
	cd -- "$cwd"
    fi
    delf -- "$tmp"
}

#########################
# Functions
#########################

# $1 message
pio_confirm() {
    read -q "REPLY?${1:-Are you sure?} (y/N) "
    printf "\n"
    [[ ! $REPLY =~ ^[Nn]$ ]]
}

pio_nuke() {
    # Nuke Antidote
    delf ~/.cache/antidote ~/.config/zsh/.zsh_plugins.zsh \
	~/.config/zsh/.zcompdump ~/.config/zsh/.zcompdump.zwc \
	~/3pp/antidote
    echo "Antidote nuked."

    # Nuke Tmux
    delf ~/.config/tmux/plugins
    echo "Tmux nuked."

    # Nuke Neovim
    delf ~/.local/share/nvim ~/.local/state/nvim ~/.cache/nvim
    echo "Neovim nuked."

    echo "Restart both shell and tmux to see effects."
}

pio_update() {
    pio_confirm "Update Antidote?" && antidote update && echo "Antidote updated."

    pio_confirm "Update Void?" && xi -Su && echo "Void updated."

    pio_confirm "Update Flatpak?" && flatpak update && echo "Flatpak updated."

    pio_confirm "Update Void packages?" && cd ~/3pp/void-packages && git pull upstream master && xi -Su \
                                        && echo "Void packages updated."

    pio_confirm "Bump Void packages?" && ~/3pp/void-packages/personal/bump.sh && echo "Void packages bumped."
}

xsearch() {
    xbps-query -Rs "$1" | sort -u | fzf --preview-window='bottom:45%:wrap' --preview 'xbps-query -Rv {2} '
}

xhold() {
    if [ -n "$1" ]; then
	sudo xbps-pkgdb -m hold $1
    else
	xpkg -H
    fi
}

xunhold() {
    sudo xbps-pkgdb -m unhold $1
}

quick_serve() {
    if [ -n "$1" ]; then
	python3 -m http.server $1
    else
	python3 -m http.server 3000
    fi
}

docker_prune_all() {
    docker container prune
    docker volume prune -a
    docker image prune -a
    docker network prune
}

# $1 folder to be encrypted and uploaded
# $2 gdrive target
# $3 password
encrypt_and_upload() {
	7z a -mhe=on -p$3 $2 $1 
	gdrive files upload $2 
}

# $1 in
# $2 pass
pio_encrypt() {
    setopt NO_HIST
    7z a -mhe=on -p$2 $1.7z $1
    unsetopt NO_HIST
}

# $1 in
pio_compress() {
    tar -cJf $1.tar.xz $1
}

# $1 in
pio_topdf() {
    echo "Converting $1"

    docker run --rm \
	--volume "$(pwd):/data" \
	--user $(id -u):$(id -g) \
	pandoc/extra "$1" -o "$1.pdf" --template eisvogel --listings
}


# $1 in file
pio_watch() {
    gamescope -w 3440 -h 1440 -r 175 -f --hdr-enabled -- mpv --panscan=1.0 $1
}
