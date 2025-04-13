# plugin configs
export ZSH_TMUX_AUTOSTART=false
export WD_CONFIG=~/.cache/.warprc
zstyle :omz:plugins:ssh-agent lazy yes
zstyle :omz:plugins:ssh-agent lifetime 4h

# antidote
source ~/.config/zsh/antidote/antidote.zsh
antidote load ~/.config/zsh/.zsh_plugins.txt
autoload -Uz compinit && compinit -i

# core export
export EDITOR=nvim
export HISTFILE=~/.cache/.zsh_history
export MANPAGER='nvim +Man!'
export MANWIDTH=999
export LC_CTYPE=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export SUDO_PROMPT=$'\u001B[1m\u001B[47m\u001B[31m[sudo]\u001B[39m\u001B[49m\u001B[22m password for \u001B[1m\u001B[100m\u001B[33m%u@%h\u001B[39m\u001B[49m\u001B[22m: '

# program export
export WGETRC=$HOME/.config/wget/.wgetrc

# lang export
export CARGO_HOME=~/3pp/cargo
NPM_PACKAGES="${HOME}/.local/npm-global"
export MANPATH="${MANPATH-$(manpath)}:$NPM_PACKAGES/share/man"
export GOPATH=$HOME/3pp/gopath
export N_PREFIX=$HOME/3pp/node
export NEXT_TELEMETRY_DISABLED=1
export PNPM_HOME="${HOME}/.local/share/pnpm"
export ANDROID_HOME=$HOME/3pp/android/sdk
export ANDROID_SDK_ROOT=$ANDROID_HOME
export FLUTTER_ROOT=$HOME/3pp/flutter

path+=(
    ~/3pp/bin
    ~/3pp/nvim/bin
    ~/.local/bin
    ~/3pp/cargo/bin
    $GOPATH/bin
    $NPM_PACKAGES/bin
    ~/stl/prefix
    $N_PREFIX/bin
    /usr/local/go/bin
    $PNPM_HOME
    ~/3pp/flutter/bin
    ~/3pp/android/sdk
    ~/3pp/android/sdk/platform-tools
)

fpath+=(
    ~/.antigen/bundles/mfaerevaag/wd/wd.sh

    # docker completion zsh > ~/path/_docker
    ~/.docker/completions
)
autoload -Uz compinit && compinit -i

# alias program
alias sudo="sudo " # make all other aliases available for sudo
                    # need additional spacing for sudo flags
alias piocopy="xclip -selection clipboard"
alias lf=lfcd
alias bcat=bat
alias ls=lsd
alias la="lsd -lAh"
alias vim=nvim
alias code="code --enable-ozone --ozone-platform=wayland"
alias open="xdg-open"
alias del=trash
alias delf="/usr/bin/rm -rf"
alias rm="echo 'use del'"
alias kimg="kitty +kitten icat"
alias clearf="/usr/bin/clear"
alias clear="clear && $HOME/.config/zsh/greeter.sh"
alias lg=lazygit
alias lzd=lazydocker
alias ip="ip -c"
alias curlget="curl -LO"

# alias git
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

# alias convenience
alias enable_ssh="sudo ln -s /etc/sv/sshd /var/service"
alias disable_ssh="sudo rm -rf /var/service/sshd"
alias xrm="sudo xbps-remove -ROo"
alias vpn_up="sudo wg-quick up /etc/wireguard/active.conf"
alias vpn_down="sudo wg-quick down /etc/wireguard/active.conf"
alias vpn_fix="sudo chown root:root -R /etc/wireguard && sudo chmod 600 -R /etc/wireguard"
alias python_venv_setup="python3 -m venv ~/3pp/python-env"
alias python_venv_activate=". ~/3pp/python-env/bin/activate"
alias python_venv_pip="~/3pp/python-env/bin/pip"

# shell
[[ ! -f ~/.config/zsh/.p10k.zsh ]] || source ~/.config/zsh/.p10k.zsh
$HOME/.config/zsh/greeter.sh
# bindkey -v # setup vim bindings

# functions

force_compinit() {
    delf ~/.cache/antigen/.zcompdump
    delf ~/.cache/antigen/.zcompdump.zwc
    compinit
}

chpwd() {
  lsd -lAh
}

lfcd () {
    # `command` is needed in case `lfcd` is aliased to `lf`
    cd "$(command lf -print-last-dir "$@")"
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


# setup correct colors for ls output
eval "$(dircolors $HOME/.config/zsh/.dircolors)"


# export PYENV_ROOT="$HOME/.pyenv"
# [[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
# eval "$(pyenv init -)"

export TERM=xterm-256color

