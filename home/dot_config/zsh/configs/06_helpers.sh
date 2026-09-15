#!/usr/bin/env bash

pio_helper_confirm() {
    local -r MSG="$1"
    read -q "?$MSG (y/N) "
    local ok=$?
    printf "\n"
    return $ok
}

pio_helper_spinner() {
    trap 'exit 0' INT TERM HUP
    local frames=(⠋ ⠙ ⠹ ⠸ ⠼ ⠴ ⠦ ⠧ ⠇ ⠏)
    local -i frame=1
    local -i SECONDS=0
    while true; do
        printf '\r\033[2K%s Checking status… %ss' "${frames[$frame]}" "$SECONDS" >&2
        frame=$((frame % ${#frames[@]} + 1))
        sleep 0.1
    done
}

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
            sudo rm -- "/var/service/$service"
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
