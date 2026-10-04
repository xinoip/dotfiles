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

# Check the current shell's network path, independently of any VPN desktop app.
# Returns 0 for verified probes, 1 for a possible leak, 2 for incomplete checks.
pio_helper_mullvad_status() {
    emulate -L zsh
    local tool
    local missing_tools=()
    for tool in curl jq; do
        command -v "$tool" &>/dev/null || missing_tools+=("$tool")
    done
    if ((${#missing_tools[@]} > 0)); then
        print -r -- "Mullvad checks unavailable (requires ${(j:, :)missing_tools})"
        return 2
    fi

    # Ignore curlrc and proxy variables: test the system route and resolver.
    # TLS verification stays enabled; each request has a bounded runtime.
    local curl_options=(--disable --silent --fail --noproxy '*' --proto '=https'
        --connect-timeout 3 --max-time 5 --header 'Accept: application/json')
    local -A probe_states=(4 unknown 6 unknown dns unknown)
    local family response probe_state
    for family in 4 6; do
        if response=$(command curl "${curl_options[@]}" "-$family" \
            "https://ipv${family}.am.i.mullvad.net/json" 2>/dev/null); then
            if probe_state=$(command jq -rs '
                if length == 1 and (.[0] | type) == "object" then
                    .[0] | if (.ip | type) == "string" and (.ip | length) > 0 then
                        if .mullvad_exit_ip == true then "on"
                        elif .mullvad_exit_ip == false then "off"
                        else "unknown" end
                    else "unknown" end
                else "unknown" end
            ' <<<"$response" 2>/dev/null); then
                probe_states[$family]="$probe_state"
            fi
        elif [[ "$family" == 6 ]] && command -v ip &>/dev/null; then
            # A failed request alone never proves IPv6 is disabled or leak-free.
            local ipv6_addresses
            if ipv6_addresses=$(command ip -6 -o address show scope global 2>/dev/null) &&
                [[ -z "$ipv6_addresses" ]]; then
                probe_states[6]=unavailable
            fi
        fi
    done

    # Use the same configuration and fresh-hostname DNS probes as mullvad.net/check.
    # The service can change its DNS test domain; accept only Mullvad subdomains.
    local dns_domain=""
    if response=$(command curl "${curl_options[@]}" https://am.i.mullvad.net/config 2>/dev/null) &&
        dns_domain=$(command jq -ers '
            select(length == 1) | .[0].dns_leak_domain | select(type == "string") |
            select(test("^dnsleak([.][a-z0-9-]+)*[.]mullvad[.]net$"))
        ' <<<"$response" 2>/dev/null) && [[ -r /proc/sys/kernel/random/uuid ]]; then
        probe_states[dns]=on
        local attempt dns_probe_id
        # Six lookups sample resolver pools and avoid cached answers.
        for attempt in {1..6}; do
            probe_state=unknown
            if dns_probe_id=$(</proc/sys/kernel/random/uuid) && [[ -n "$dns_probe_id" ]] &&
                response=$(command curl "${curl_options[@]}" \
                    "https://${dns_probe_id//-/}.$dns_domain" 2>/dev/null); then
                probe_state=$(command jq -rs '
                    if length == 1 and (.[0] | type) == "array" then
                        .[0] |
                        if any(.[]; if type == "object" then .mullvad_dns == false else false end)
                        then "off"
                        elif length > 0 and all(.[];
                            if type == "object" then
                                .mullvad_dns == true and (.ip | type) == "string" and (.ip | length) > 0
                            else false end)
                        then "on"
                        else "unknown" end
                    else "unknown" end
                ' <<<"$response" 2>/dev/null) || probe_state=unknown
            fi
            if [[ "$probe_state" == off ]]; then
                probe_states[dns]=off
                break
            elif [[ "$probe_state" != on ]]; then
                probe_states[dns]=unknown
            fi
        done
    fi

    local details=()
    for family in 4 6; do
        case "${probe_states[$family]}" in
        on) details+=("IPv$family via Mullvad") ;;
        off) details+=("IPv$family bypasses Mullvad") ;;
        unavailable) details+=("IPv6 unavailable (no global address)") ;;
        *) details+=("IPv$family check inconclusive") ;;
        esac
    done
    case "${probe_states[dns]}" in
    on) details+=("DNS via Mullvad (6 probes)") ;;
    off) details+=("possible DNS leak (non-Mullvad resolver)") ;;
    *) details+=("DNS check inconclusive") ;;
    esac
    print -r -- "${(j:; :)details}"
    [[ "${probe_states[4]}" == off || "${probe_states[6]}" == off || "${probe_states[dns]}" == off ]] && return 1
    [[ "${probe_states[4]}" == on && "${probe_states[6]}" == (on|unavailable) && "${probe_states[dns]}" == on ]] && return 0
    return 2
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
