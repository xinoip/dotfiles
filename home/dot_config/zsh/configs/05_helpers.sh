#!/usr/bin/env bash

# Show an interactive confirmation prompt. $1 is the message to display.
pio_helper_confirm() {
    local -r MSG="$1"
    read -q "?$MSG (y/N) "
    local ok=$?
    printf "\n"
    return $ok
}

# Check whether a command exists. Prints a message only when it is missing.
pio_helper_check_command() {
    local tool="$1"
    if ! command -v "$tool" &>/dev/null; then
        print -r -- "❌ $tool not available"
        return 1
    fi
}

# Common curl wrapper.
pio_helper_curl() {
    command curl --disable --fail --silent --show-error --proto '=https' \
        --connect-timeout 3 --max-time 5 "$@"
}

# Common curl wrapper with no proxy.
pio_helper_curl_direct() {
    pio_helper_curl --noproxy '*' "$@"
}

# Toggle a Void service.
pio_void_toggle_service() {
    local service="$1"
    if [[ $# -ne 1 || -z "$service" || "$service" == .* || "$service" == *[^a-zA-Z0-9_-]* ]]; then
        echo "Usage: pio_void_toggle_service <service>" >&2
        return 1
    fi

    if ${PIOBUNTU:-false}; then
        echo "Toggling $service not supported on Ubuntu for now."
        return 1
    fi

    if [[ -L "/var/service/$service" ]]; then
        echo "Disabling $service..."
        sudo sv down "/var/service/$service" &&
            sudo delf -- "/var/service/$service"
    elif [[ -e "/var/service/$service" ]]; then
        echo "Cannot toggle $service: /var/service/$service is not a symlink." >&2
        return 1
    elif [[ -d "/etc/sv/$service" ]]; then
        echo "Enabling $service..."
        sudo ln -s "/etc/sv/$service" "/var/service/$service"
    else
        echo "Service not found: /etc/sv/$service" >&2
        return 1
    fi
}

# Eagerly get sudo permissions if not already present.
pio_helper_get_sudo() {
    if [[ $EUID -ne 0 ]]; then
        echo "🔑 Eagerly getting sudo permissions"
        sudo -v || return 1
    fi
}

# Add the YubiKey to ssh-agent if it's not already there.
pio_helper_add_yubikey() {
    local key_pub_path="$HOME/.ssh/personal/yubikey.pub"
    local key_pub_info
    if ! key_pub_info=$(ssh-keygen -lf "$key_pub_path" 2>/dev/null); then
        print -r -- "❔ Unable to read YubiKey public key: $key_pub_path"
        return 1
    fi

    local key_pub_id
    if ! key_pub_id=$(awk '{print $2}' <<< "$key_pub_info") || [[ -z "$key_pub_id" ]]; then
        print -r -- "❔ Unable to read YubiKey fingerprint: $key_pub_path"
        return 1
    fi

    if ! ssh-add -l | grep -qF "$key_pub_id"; then
        echo "🔑 ssh-add YubiKey"
        ssh-add "${key_pub_path%.pub}"
    fi
}

# Reset the $SECONDS shell builtin to 0.
pio_helper_reset_seconds() {
    SECONDS=0
}

# Show a spinner. $1 is the message to display during the spin.
pio_helper_spinner() {
    trap 'return 0' INT TERM HUP

    local frames=(⣾ ⣽ ⣻ ⢿ ⡿ ⣟ ⣯ ⣷)
    local frames_len=${#frames[@]}
    local -i frame=1
    local msg="$1"

    while true; do
        printf '\r\033[2K%s %s … %ss %s' "${frames[$frame]}" "$msg" "$SECONDS" >&2
        frame=$(( frame % frames_len + 1 ))
        sleep 0.1
    done
}

# Run a command with a spinner. $1 is the message to display during the spin. Spinner goes away after the command is
# complete. This immediately runs in a subshell (hence the paranthese). It makes zsh to hide away PID message outputs on
# background processes. Command shouldn't have any interactive prompts.
pio_helper_spin() (
    local msg="$1"
    shift

    # stdout may be captured by the caller; the spinner only needs a terminal on stderr.
    if [[ ! -t 2 || "${TERM:-dumb}" == dumb ]]; then
        "$@"
        return $?
    fi

    setopt localtraps no_monitor
    trap 'return 130' INT
    trap 'return 143' TERM
    trap 'return 129' HUP
    local spinner_pid=""
    local rc=0
    {
        pio_helper_spinner "$msg" &!
        spinner_pid=$!

        "$@"
        rc=$?
    } always {
        if [[ -n "$spinner_pid" ]]; then
            kill "$spinner_pid" 2>/dev/null
            wait "$spinner_pid" 2>/dev/null
            printf '\r\033[2K' >&2
        fi
    }

    return "$rc"
)
