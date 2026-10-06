pio_listeners() {
    local tool
    for tool in ss ip column; do
        if ! pio_helper_check_command "$tool" >/dev/null; then
            echo "$tool is required for pio_listeners." >&2
            return 1
        fi
    done

    local listeners
    listeners=$(sudo ss -H -lntup) || return 1
    if [[ -z "$listeners" ]]; then
        echo "No TCP or UDP listeners."
        return 0
    fi

    local -A interfaces
    local addresses
    local line
    local fields=()
    if addresses=$(ip -o address show 2>/dev/null); then
        for line in "${(@f)addresses}"; do
            fields=(${(z)line})
            interfaces[${fields[4]%/*}]=${fields[2]%%@*}
        done
    fi

    local -A wireguard_ports
    local wireguard_status
    if pio_helper_check_command wg >/dev/null &&
        wireguard_status=$(sudo -n wg show all listen-port 2>/dev/null); then
        for line in "${(@f)wireguard_status}"; do
            fields=(${(z)line})
            if [[ ${#fields[@]} -eq 2 && "${fields[2]}" == <1-65535> ]]; then
                if [[ -n "${wireguard_ports[${fields[2]}]:-}" ]]; then
                    wireguard_ports[${fields[2]}]+=", ${fields[1]}"
                else
                    wireguard_ports[${fields[2]}]="${fields[1]}"
                fi
            fi
        done
    fi

    local external_rows=()
    local loopback_rows=()
    local row
    local MATCH MBEGIN MEND
    local match mbegin mend
    for line in "${(@f)listeners}"; do
        fields=(${(z)line})
        local protocol="${fields[1]:u}"
        local endpoint="${fields[5]}"
        local port="${endpoint##*:}"
        local address="${${endpoint%:*}//[\[\]]/}"
        local interface="${interfaces[${address%%%*}]:-}"
        [[ "$address" == *%* ]] && interface="${address##*%}"
        local scope="Unknown interface"
        local loopback=false

        if [[ "$address" == 127.* || "$address" == ::1 || "$interface" == lo ]]; then
            scope="Loopback only"
            loopback=true
        elif [[ -n "$interface" ]]; then
            if [[ -d "/sys/class/net/$interface/wireless" ]]; then
                scope="$interface (Wi-Fi)"
            elif [[ -e "/sys/class/net/$interface/device" ]]; then
                scope="$interface (physical)"
            elif [[ -d "/sys/class/net/$interface/bridge" || "$interface" == virbr* ]]; then
                scope="$interface (virtual bridge)"
            elif [[ -e "/sys/class/net/$interface/tun_flags" || "$interface" == (wg*|tailscale*|mullvad*) ]]; then
                scope="$interface (VPN/tunnel)"
            else
                scope="$interface"
            fi
        elif [[ "$address" == 0.0.0.0 ]]; then
            scope="All IPv4 interfaces"
        elif [[ "$address" == :: ]]; then
            scope="All IPv6 interfaces"
        elif [[ "$address" == '*' ]]; then
            scope="All interfaces"
        fi

        local owners="${line#*users:}"
        local processes=()
        while [[ "$owners" =~ '"([^"]+)",pid=([0-9]+)' ]]; do
            processes+=("${match[1]} (${match[2]})")
            owners="${owners#*pid=${match[2]}}"
        done
        local process="${(j:, :)processes}"
        if [[ -z "$process" && "$protocol" == UDP && -n "${wireguard_ports[$port]:-}" ]]; then
            process="WireGuard (${wireguard_ports[$port]})"
        fi
        row="${process:-unknown}"$'\t'"$protocol"$'\t'"$address"$'\t'"$port"$'\t'"$scope"
        if $loopback; then
            loopback_rows+=("$row")
        else
            external_rows+=("$row")
        fi
    done

    local rows=("PROCESS (PID)"$'\t'"PROTOCOL"$'\t'"ADDRESS"$'\t'"PORT"$'\t'"LISTENING ON"
        "${external_rows[@]}" "${loopback_rows[@]}")
    print -rl -- "${rows[@]}" | column -t -s $'\t'
}

