#!/usr/bin/env bash

setup() {
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
        "$HOME/.local/share/pnpm/bin"
        "$HOME/3pp/vscode/bin"
    )
}

setup
unset -f setup
