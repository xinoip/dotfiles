# Check Mullvad status against official Mullvad API.
pio_helper_check_mullvad() {
    pio_helper_check_command curl || return 1

    pio_helper_check_command jq || return 1

    local dns_leak_id
    if ! dns_leak_id=$(openssl rand -hex 16); then
        print -r -- "❔ unable to generate random ID for DNS leak check."
        return 1
    fi

    local domain
    if ! domain=$(pio_helper_curl https://am.i.mullvad.net/config | jq -r .dns_leak_domain); then
        print -r -- "❔ unable to get DNS leak domain."
        return 1
    fi

    if ! pio_helper_curl_direct "https://$dns_leak_id.$domain/" &>/dev/null; then
        print -r -- "❔ unable to check DNS leak."
        return 1
    fi

    local dns_leak_result
    if ! dns_leak_result=$(pio_helper_curl https://am.i.mullvad.net/dnsleak/"$dns_leak_id" | jq -r '.[0].mullvad_dns' 2>/dev/null); then
        print -r -- "❔ unable to check DNS leak result. id: $dns_leak_id"
        return 1
    fi

    case "$dns_leak_result" in
        true)
            ;;
        false)
            print -r -- "❌ Mullvad DNS leak"
            ;;
        *)
            print -r -- "❔ DNS leak result unknown: $dns_leak_result"
            return 1
            ;;
    esac

    local connected_res
    if ! connected_res=$(pio_helper_curl_direct https://am.i.mullvad.net/connected 2>/dev/null); then
        print -r -- "❔ unable to check connection status"
        return 1
    fi

    if ! grep -q '^You are connected to Mullvad' <<< "$connected_res"; then
        print -r -- "❌ Mullvad"
    fi
}


# Check the status of UFW. Prints a message and returns 0 if active, 1 otherwise.
pio_helper_check_ufw_status() {
    pio_helper_check_command ufw || return 1

    local ufw_status
    if ! ufw_status=$(sudo -n env LC_ALL=C ufw status 2>/dev/null); then
        print -r -- "❔ Unable to check UFW status"
        return 1
    fi

    case "$ufw_status" in
        *"Status: active"*)
            ;;
        *"Status: inactive"*)
            print -r -- "❌ UFW is inactive"
            return 1
            ;;
        *)
            print -r -- "❔ UFW status is unknown"
            return 1
            ;;
    esac
}

# Check WireGuard status to list active interfaces.
pio_helper_check_wireguard_status() {
    pio_helper_check_command ip || return 1
    pio_helper_check_command wg || return 1

    local wg_ifaces
    if ! wg_ifaces=$(sudo -n wg show interfaces 2>/dev/null); then
        print -r -- "❔ Unable to check WireGuard interfaces"
        return 1
    fi

    local wg_iface
    local active_wg_links=()
    for wg_iface in ${=wg_ifaces}; do
        local wg_link=""
        if ! wg_link=$(ip -o link show dev "$wg_iface" up 2>/dev/null); then
            print -r -- "❔ Unable to check WireGuard interface link for $wg_iface"
            return 1
        fi

        if [[ -n "$wg_link" ]]; then
            active_wg_links+=("$wg_iface")
        fi
    done

    if ((${#active_wg_links[@]} > 0)); then
        print -r -- "🚧 WireGuard has some links: ${#active_wg_links[@]}"
    fi
}

# Check a repository. Fetches and prints issues if its out of sync. $1 is the path to the repository.
pio_helper_check_git_status() {
    local repo="$1"

    pio_helper_check_command git || return 1

    if ! git -C "$repo" fetch --all --quiet &>/dev/null; then
        print -r -- "❌ failed to fetch repo: $repo"
        return 1
    fi

    local uncommitted=""
    if ! uncommitted=$(git -C "$repo" status --porcelain 2>/dev/null); then
        print -r -- "❌ failed to check uncommited on repo: $repo"
        return 1
    fi

    local branch_status=""
    if ! branch_status=$(git -C "$repo" status -sb 2>/dev/null); then
        print -r -- "❌ failed to check branch status on repo: $repo"
        return 1
    fi

    if [[ -n "$uncommitted" ]]; then
        print -r -- "❌ uncommitted changes on repo: $repo"
        return 1
    fi

    branch_status="${branch_status%%$'\n'*}"
    case "$branch_status" in
        *'[ahead '*)
            print -r -- "❌ needs push on repo: $repo"
            ;;
        *'[behind '* | *', behind '*)
            print -r -- "❌ needs pull on repo: $repo"
            ;;
    esac
}

# Check unapplied chezmoi changes and the dotfiles repository.
pio_helper_check_chezmoi_status() {
    pio_helper_check_command chezmoi || return 1

    local chezmoi_status=""
    local result=0
    if ! chezmoi_status=$(chezmoi status 2>/dev/null); then
        print -r -- "❔ Unable to check unapplied chezmoi changes"
        result=1
    elif [[ -n "$chezmoi_status" ]]; then
        print -r -- "🚧 Unapplied chezmoi changes"
    fi

    pio_helper_check_git_status "$HOME/.local/share/chezmoi" || result=1
    return "$result"
}

# Check Void updates and the void-packages repository.
pio_helper_check_void_status() {
    pio_helper_check_command xbps-install || return 1

    local updates=""
    local result=0
    if ! updates=$(xbps-install -unM 2>/dev/null); then
        print -r -- "❔ Unable to check Void updates"
        result=1
    elif [[ -n "$updates" ]]; then
        local update_lines=("${(@f)updates}")
        print -r -- "🚧 Void updates (${#update_lines[@]})"
        result=1
    fi

    pio_helper_check_git_status "$HOME/3pp/void-packages" || result=1
    return "$result"
}

# Check whether a folder exists. $1 is the path to the folder.
pio_helper_check_folder_exists() {
    local folder="$1"
    if ! [[ -d "$folder" ]]; then
        print -r -- "❌ $folder not found"
        return 1
    fi
}

# Checks a folder for emptyness. $1 is the path, $2 is an optional filename to ignore.
pio_helper_check_folder_empty() {
    local folder="$1"
    if ! [[ -d "$folder" ]]; then
        print -r -- "❌ $folder not found"
        return 1
    fi

    local items=("$folder"/*(ND))
    local count=${#items[@]}
    if [[ -n "$2" && -f "$folder/$2" ]]; then
        ((count -= 1))
    fi
    if ((count > 0)); then
        print -r -- "🚧 $folder is not empty: ($count)"
    fi
}

# Check whether the todo file has any lines left.
pio_helper_check_todo_status() {
    if ! [[ -f "$PIO_TODO_FILE" ]]; then
        print -r -- "❌ todo file not found"
        return 1
    fi

    local todo_count=0
    if ! todo_count=$(wc -l <"$PIO_TODO_FILE"); then
        print -r -- "❔ unable to check todo file"
        return 1
    fi

    if [ $todo_count -gt 0 ]; then
        print -r -- "🚧 todos ($todo_count)"
    fi
}

# Check whether the Tailscale daemon is running.
pio_helper_check_tailscale() {
    pio_helper_check_command pgrep || return 1

    local tailscale_result=0
    pgrep -x tailscaled &>/dev/null || tailscale_result=$?
    case "$tailscale_result" in
        0)
            ;;
        1)
            print -r -- "❌ Tailscale is not running"
            ;;
        *)
            print -r -- "❔ Unable to check Tailscale status"
            ;;
    esac
}

# Check SSH daemon status.
pio_helper_check_sshd() {
    pio_helper_check_command pgrep || return 1

    local service_result=0
    pgrep -x sshd &>/dev/null || service_result=$?
    case "$service_result" in
        0)
            print -r -- "👀 SSH daemon is running"
            ;;
        1)
            ;;
        *)
            print -r -- "❔ Unable to check SSH status"
            return 1
            ;;
    esac
}

# Ultimate system status checker.
pio_status() {
    pio_helper_add_yubikey || return 1
    pio_helper_get_sudo || return 1
    pio_helper_reset_seconds

    # Prevent git from prompting things.
    local -x GIT_TERMINAL_PROMPT=0
    local -x GIT_SSH_COMMAND="${GIT_SSH_COMMAND:-ssh} -o BatchMode=yes"
    local report=()

    report+=("$(pio_helper_spin "Checking UFW" pio_helper_check_ufw_status)")
    report+=("$(pio_helper_spin "Checking WireGuard" pio_helper_check_wireguard_status)")
    report+=("$(pio_helper_spin "Checking Tailscale" pio_helper_check_tailscale)")
    report+=("$(pio_helper_spin "Checking SSH" pio_helper_check_sshd)")

    report+=("$(pio_helper_spin "Checking chezmoi" pio_helper_check_chezmoi_status)")
    if [[ -r /etc/os-release ]] && [[ "$(. /etc/os-release; print -r -- "$ID")" == void ]]; then
        report+=("$(pio_helper_spin "Checking Void" pio_helper_check_void_status)")
    fi

    report+=("$(pio_helper_spin "Checking sync folder" pio_helper_check_folder_exists "$HOME/sync")")
    report+=("$(pio_helper_spin "Checking picture folder" pio_helper_check_folder_exists "$HOME/sync/picture")")
    report+=("$(pio_helper_spin "Checking vault folder" pio_helper_check_folder_exists "$HOME/sync/vault")")
    report+=("$(pio_helper_spin "Checking brain folder" pio_helper_check_folder_exists "$HOME/sync/brain")")

    report+=("$(pio_helper_spin "Checking vault" pio_helper_check_git_status "$HOME/sync/vault")")
    report+=("$(pio_helper_spin "Checking brain" pio_helper_check_git_status "$HOME/sync/brain")")

    report+=("$(pio_helper_spin "Checking download" pio_helper_check_folder_empty "$HOME/download")")
    report+=("$(pio_helper_spin "Checking trash" pio_helper_check_folder_empty "$HOME/.local/share/Trash/files")")
    report+=("$(pio_helper_spin "Checking tmp" pio_helper_check_folder_empty "$HOME/tmp")")
    report+=("$(pio_helper_spin "Checking desktop" pio_helper_check_folder_empty "$(xdg-user-dir DESKTOP 2>/dev/null)" .directory)")

    report+=("$(pio_helper_spin "Checking todos" pio_helper_check_todo_status)")
    report+=("$(pio_helper_spin "Checking Mullvad" pio_helper_check_mullvad)")

    # Git checks can succeed without returning a message.
    print -rl -- "${(@)report:#}"
}
