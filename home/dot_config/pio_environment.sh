#!/usr/bin/env zsh

# Make sure XDG variables are available:
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"
export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
export XDG_STATE_HOME="${XDG_STATE_HOME:-$HOME/.local/state}"

# I'm not supporting Ubuntu ATM:
export PIOBUNTU=false

# Sane defaults:
export EDITOR='nvim'
export VISUAL='nvim'
export PAGER='bat'
export MANPAGER='nvim +Man!'
export MANWIDTH=999
export LANG='en_US.UTF-8'
export LC_CTYPE='en_US.UTF-8'
export LC_ALL='en_US.UTF-8'

# Go:
export GOPATH="$HOME/3pp/gopath"

# Rust:
export CARGO_HOME="$HOME/3pp/cargo"

# Node:
NPM_PACKAGES="$HOME/.local/npm-global"
export N_PREFIX="$HOME/3pp/node"
export NEXT_TELEMETRY_DISABLED=1
export PNPM_HOME="$HOME/.local/share/pnpm"
export NPM_CONFIG_USERCONFIG="$HOME/.config/npm/npmrc"
export NPM_CONFIG_CACHE="$HOME/.cache/npm"

# Flutter:
export ANDROID_HOME="$HOME/3pp/android"
export ANDROID_SDK_ROOT="$ANDROID_HOME"
export ANDROID_USER_HOME="$HOME/.config/android"
export FLUTTER_ROOT="$HOME/3pp/flutter"
export CHROME_EXECUTABLE="/usr/bin/chromium"
export PUB_CACHE="$HOME/.cache/pub"

# Docker:
export DOCKER_CONFIG="$HOME/.config/docker"

# GnuPG:
export GNUPGHOME="$HOME/.config/gnupg"

# Java:
export GRADLE_USER_HOME="$HOME/.config/gradle"

# Codex:
export CODEX_HOME="$HOME/.local/share/codex"

# Ollama:
export OLLAMA_HOME="$HOME/.local/share/ollama"
export OLLAMA_MODELS="$XDG_DATA_HOME/ollama/models"

# GTK:
export GTK2_RC_FILES="$HOME/.config/gtk-2.0/gtkrc"

# Wget:
export WGETRC="$HOME/.config/wget/.wgetrc"

# Do not track me:
export GH_TELEMETRY=false
export DO_NOT_TRACK=true

# Things related to my dotfile configuration:
export PIO_TODO_FILE="${PIO_TODO_FILE:-$HOME/sync/vault/.todos}"
export PIO_WD_FILE="${PIO_WD_FILE:-$HOME/sync/vault/.warp_dirs}"

# Eye candies:
export LS_COLORS="rs=0:di=01;34:ln=01;36:mh=00:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:mi=00:su=37;41:sg=30;43:ca=00:tw=30;42:ow=34;42:st=37;44:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arc=01;31:*.arj=01;31:*.taz=01;31:*.lha=01;31:*.lz4=01;31:*.lzh=01;31:*.lzma=01;31:*.tlz=01;31:*.txz=01;31:*.tzo=01;31:*.t7z=01;31:*.zip=01;31:*.z=01;31:*.dz=01;31:*.gz=01;31:*.lrz=01;31:*.lz=01;31:*.lzo=01;31:*.xz=01;31:*.zst=01;31:*.tzst=01;31:*.bz2=01;31:*.bz=01;31:*.tbz=01;31:*.tbz2=01;31:*.tz=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.war=01;31:*.ear=01;31:*.sar=01;31:*.rar=01;31:*.alz=01;31:*.ace=01;31:*.zoo=01;31:*.cpio=01;31:*.7z=01;31:*.rz=01;31:*.cab=01;31:*.wim=01;31:*.swm=01;31:*.dwm=01;31:*.esd=01;31:*.avif=01;35:*.jpg=01;35:*.jpeg=01;35:*.mjpg=01;35:*.mjpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.svg=01;35:*.svgz=01;35:*.mng=01;35:*.pcx=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.m2v=01;35:*.mkv=01;35:*.webm=01;35:*.webp=01;35:*.ogm=01;35:*.mp4=01;35:*.m4v=01;35:*.mp4v=01;35:*.vob=01;35:*.qt=01;35:*.nuv=01;35:*.wmv=01;35:*.asf=01;35:*.rm=01;35:*.rmvb=01;35:*.flc=01;35:*.avi=01;35:*.fli=01;35:*.flv=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.yuv=01;35:*.cgm=01;35:*.emf=01;35:*.ogv=01;35:*.ogx=01;35:*.aac=00;36:*.au=00;36:*.flac=00;36:*.m4a=00;36:*.mid=00;36:*.midi=00;36:*.mka=00;36:*.mp3=00;36:*.mpc=00;36:*.ogg=00;36:*.ra=00;36:*.wav=00;36:*.oga=00;36:*.opus=00;36:*.spx=00;36:*.xspf=00;36:*~=00;90:*#=00;90:*.bak=00;90:*.crdownload=00;90:*.dpkg-dist=00;90:*.dpkg-new=00;90:*.dpkg-old=00;90:*.dpkg-tmp=00;90:*.old=00;90:*.orig=00;90:*.part=00;90:*.rej=00;90:*.rpmnew=00;90:*.rpmorig=00;90:*.rpmsave=00;90:*.swp=00;90:*.tmp=00;90:*.ucf-dist=00;90:*.ucf-new=00;90:*.ucf-old=00;90:"
export SUDO_PROMPT=$'\u001B[1m\u001B[47m\u001B[31m[sudo]\u001B[39m\u001B[49m\u001B[22m password for \u001B[1m\u001B[100m\u001B[33m%u@%h\u001B[39m\u001B[49m\u001B[22m: '

# Remove duplicates in $PATH:
typeset -gU path

# Local binaries and wrappers should take  higher priority than system alternatives:
path=("$HOME/.local/bin" "${path[@]}")

# Rest of the $PATH:
path+=(
    "$HOME/3pp/bin"
    "$HOME/3pp/nvim/bin"
    "$HOME/3pp/cargo/bin"
    "$GOPATH/bin"
    "$NPM_PACKAGES/bin"
    "$HOME/stl/prefix"
    "$N_PREFIX/bin"
    "/usr/local/go/bin"
    "$PNPM_HOME"
    "$HOME/3pp/flutter/bin"
    "$HOME/.opencode/bin"
    "$HOME/.local/share/pnpm/bin"
    "$HOME/3pp/vscode/bin"
)
export PATH

# This is only meaningful for an interactive shell. Sets GPG password prompt behavior:
if [[ -o interactive && -t 0 && -n ${TTY-} ]]; then
    export GPG_TTY="$TTY"
fi
