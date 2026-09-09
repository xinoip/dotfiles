#!/usr/bin/env bash

# This script doesn't support lazy loading of keys into the agent. Use 'AddKeysToAgent' in your ssh config to get
# support for that.

setup() {
    local SSH_ENV="$HOME/.ssh/pio_env"
    if [ ! -f "$SSH_ENV" ]; then
        mkdir -p "$HOME/.ssh"
        touch "$SSH_ENV"
    fi

    # shellcheck disable=SC1090
    . "$SSH_ENV" >/dev/null

    if ! ps -p "${SSH_AGENT_PID}" >/dev/null 2>&1; then
        ssh-agent | sed 's/^echo/#echo/' >"${SSH_ENV}"
        chmod 600 "${SSH_ENV}"

        # shellcheck disable=SC1090
        . "${SSH_ENV}" >/dev/null
    fi
}

setup
unset -f setup
