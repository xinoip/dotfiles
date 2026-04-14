#!/bin/zsh

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
export NPM_CONFIG_CACHE="$XDG_CACHE_HOME/npm"
# Android/Flutter
export ANDROID_HOME="$HOME/3pp/android"
export ANDROID_SDK_ROOT="$ANDROID_HOME"
export ANDROID_USER_HOME="$HOME/.config/android"
export FLUTTER_ROOT="$HOME/3pp/flutter"
export PUB_CACHE="$XDG_CACHE_HOME/pub"
# Docker
export DOCKER_CONFIG="$HOME/.config/docker"
# GnuPG
export GNUPGHOME="$HOME/.config/gnupg"
# Java
export GRADLE_USER_HOME="$HOME/.config/gradle"
# Ollama
export OLLAMA_HOME="$XDG_DATA_HOME/ollama"
# GTK
export GTK2_RC_FILES="$HOME/.config/gtk-2.0/gtkrc"
# Wget
export WGETRC="~/.config/wget/.wgetrc"

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
    "$HOME/.opencode/bin"
)
