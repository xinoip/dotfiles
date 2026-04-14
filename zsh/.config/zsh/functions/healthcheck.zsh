#!/bin/zsh

function pio_healthcheck() {
    if ! command -v tree-sitter &>/dev/null; then
        echo "Warning: tree-sitter not found in PATH" >&2
    fi

    if $PIOBUNTU; then
        if ! dpkg -l python3 &>/dev/null || ! dpkg -l python3-venv &>/dev/null; then
            echo "Warning: python3 and/or python3-venv not installed" >&2
        fi
    fi

    if ! command -v npm &>/dev/null; then
        echo "Warning: npm not found in PATH" >&2
    elif [[ $(npm config get registry) != "https://registry.npmjs.org/" ]]; then
        echo "Warning: npm registry is not set to default (https://registry.npmjs.org/)" >&2
    fi

}
