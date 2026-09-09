#!/usr/bin/env bash

setup() {
    # Determine if we are running on Ub*ntu.
    export PIOBUNTU=false
    if [[ -f /etc/lsb-release ]] && grep -q "Ubuntu" /etc/lsb-release; then
        PIOBUNTU=true
    fi

    export EDITOR='nvim'
    export VISUAL='nvim'
    export MANPAGER='nvim +Man!'
    export MANWIDTH=999
    export LANG='en_US.UTF-8'
    export LC_CTYPE='en_US.UTF-8'
    export LC_ALL='en_US.UTF-8'

    # Batcat on Ubuntu is different and kinda broken.
    if [[ "$PIOBUNTU" == true ]]; then
        export PAGER=''
    else
        export PAGER='bat'
    fi

    # GPG TUI password prompt needs it.
    local active_tty
    active_tty=$(tty)
    export GPG_TTY=$active_tty

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
    export NPM_CONFIG_USERCONFIG="$HOME/.config/npm/npmrc"
    export NPM_CONFIG_CACHE="$HOME/.cache/npm"
    # Android/Flutter
    export ANDROID_HOME="$HOME/3pp/android"
    export ANDROID_SDK_ROOT="$ANDROID_HOME"
    export ANDROID_USER_HOME="$HOME/.config/android"
    export FLUTTER_ROOT="$HOME/3pp/flutter"
    export CHROME_EXECUTABLE="/usr/bin/chromium"
    export PUB_CACHE="$HOME/.cache/pub"
    # Docker
    export DOCKER_CONFIG="$HOME/.config/docker"
    # GnuPG
    export GNUPGHOME="$HOME/.config/gnupg"
    # Java
    export GRADLE_USER_HOME="$HOME/.config/gradle"
    # Ollama
    export OLLAMA_HOME="$HOME/.local/share/ollama"
    # GTK
    export GTK2_RC_FILES="$HOME/.config/gtk-2.0/gtkrc"
    # Wget
    export WGETRC="$HOME/.config/wget/.wgetrc"
}

setup
unset -f setup
