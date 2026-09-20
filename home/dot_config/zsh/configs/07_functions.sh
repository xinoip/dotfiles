#!/usr/bin/env bash

pio_docker_prune() {
    pio_helper_confirm "Prune Docker images?" && docker image prune -a
    pio_helper_confirm "Prune Docker containers?" && docker container prune
    pio_helper_confirm "Prune Docker volumes?" && docker volume prune -a
    pio_helper_confirm "Prune Docker networks?" && docker network prune
}

# thx to https://piechowski.io/post/git-commands-before-reading-code/ and AI for slop emojis
pio_git_stats() {
    echo "========================================="
    echo "       GIT REPOSITORY AT A GLANCE        "
    echo "========================================="

    echo -e "\n🔥 WHAT CHANGES THE MOST (Top 20 high-churn files in the last year):"
    git log --format=format: --name-only --since="1 year ago" | awk NF | sort | uniq -c | sort -nr | head -20

    echo -e "\n👷 WHO BUILT THIS (Contributors ranked by commit count):"
    git shortlog -sn --no-merges

    echo -e "\n🐛 WHERE BUGS CLUSTER (Top 20 files matching fix/bug/broken):"
    git log -i -E --grep="fix|bug|broken" --name-only --format='' | awk NF | sort | uniq -c | sort -nr | head -20

    echo -e "\n📈 IS THIS PROJECT ACCELERATING OR DYING? (Commits per month):"
    git log --format='%ad' --date=format:'%Y-%m' | sort | uniq -c

    echo -e "\n🚨 HOW OFTEN IS THE TEAM FIREFIGHTING? (Revert/hotfix/rollback in the last year):"
    git log --oneline --since="1 year ago" | grep -iE 'revert|hotfix|emergency|rollback' || echo "(No firefighting commits found)"

    echo -e "\n========================================="
}

pio_note() {
    local note_file
    note_file="$HOME/vault/note_$(date +%Y%m%d%H%M%S).md"
    $EDITOR "$note_file"
}

pio_prompt() {
    local name="$1"
    local prompt_folder="$HOME/brain/sessions/$name"

    mkdir -p "$prompt_folder"
    cd "$prompt_folder" || return 1
    touch .gitkeep
    git init && gac
    codex
}

pio_serve() {
    if [ -n "$1" ]; then
        python3 -m http.server "$1"
    else
        python3 -m http.server 3000
    fi
}

pio_update() {
    if $PIOBUNTU; then
        pio_helper_confirm "Update Ubuntu?" && sudo apt update && sudo apt upgrade && echo "Ubuntu updated."
    else
        pio_helper_confirm "Update Void?" &&
            xi -Su &&
            cd $HOME/3pp/void-packages &&
            ./personal/update.sh &&
            echo "Void updated."
    fi

    if [[ -f /usr/bin/flatpak ]]; then
        pio_helper_confirm "Update Flatpak?" && flatpak update && echo "Flatpak updated."
    fi
}

pio_toggle_sshd() {
    pio_void_toggle_service sshd
}

pio_toggle_tailscale() {
    pio_void_toggle_service tailscaled
}

pio_listeners() {
    local tool
    for tool in ss ip column; do
        if ! command -v "$tool" &>/dev/null; then
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
    if command -v wg &>/dev/null &&
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

pio_status() {
    if ! ssh-add -l &>/dev/null; then
        echo "🔑 ssh-add"
        ssh-add "$HOME/.ssh/personal/yubikey" || return 1
    fi
    if [[ $EUID -ne 0 ]]; then
        echo "🔑 sudo"
        sudo -v || return 1
    fi

    local -x GIT_TERMINAL_PROMPT=0
    local -x GIT_SSH_COMMAND="${GIT_SSH_COMMAND:-ssh} -o BatchMode=yes"
    local report=()

    setopt localoptions localtraps no_monitor
    trap 'return 130' INT
    trap 'return 143' TERM
    trap 'return 129' HUP
    local spinner_pid=""
    {
        if [[ -t 1 && -t 2 && "${TERM:-dumb}" != dumb ]]; then
            pio_helper_spinner &
            spinner_pid=$!
        fi

        # Read UFW while the sudo credentials are fresh.
        local ufw_status=""
        local ufw_checked=false
        if command -v ufw &>/dev/null; then
            if ufw_status=$(sudo -n env LC_ALL=C ufw status 2>/dev/null); then
                ufw_checked=true
            fi
        fi

        local repos=(
            "$HOME/.local/share/chezmoi"
            "$HOME/repo/notes"
            "$HOME/3pp/void-packages"
            "$HOME/vault"
            "$HOME/brain"
        )

        local repo
        for repo in "${repos[@]}"; do
            local reponame=${repo##*/}
            local fetch_ok=true
            git -C "$repo" fetch --all --quiet &>/dev/null || fetch_ok=false

            local uncommitted=""
            local branch_status=""
            if ! uncommitted=$(git -C "$repo" status --porcelain 2>/dev/null) ||
                ! branch_status=$(git -C "$repo" status -sb 2>/dev/null); then
                report+=("❔ $reponame (unable to check)")
                continue
            fi

            local needs_commit=false
            local needs_push=false
            local needs_pull=false
            local needs_apply=false

            if [[ "$repo" == "$HOME/.local/share/chezmoi" ]]; then
                local chezmoi_status=""
                if ! chezmoi_status=$(chezmoi status 2>/dev/null); then
                    report+=("❔ $reponame (unable to check unapplied changes)")
                    continue
                fi
                [[ -n "$chezmoi_status" ]] && needs_apply=true
            fi

            [[ -n "$uncommitted" ]] && needs_commit=true
            [[ "$branch_status" == *"ahead"* ]] && needs_push=true
            [[ "$branch_status" == *"behind"* ]] && needs_pull=true

            if ! $fetch_ok; then
                report+=("🚧 $reponame (fetch failed)")
            elif ! $needs_commit && ! $needs_push && ! $needs_pull && ! $needs_apply; then
                report+=("✅ $reponame")
            else
                report+=("🚧 $reponame")
            fi
        done

        local dirs=(
            "$HOME/tmp:tmp"
            "$HOME/download:download"
            "$HOME/.local/share/Trash/files:trash"
            "$(xdg-user-dir DESKTOP 2>/dev/null):desktop"
        )

        local entry
        for entry in "${dirs[@]}"; do
            local dir="${entry%:*}"
            local dir_name="${entry##*:}"

            if [[ -d "$dir" ]]; then
                local items=("$dir"/*(ND))
                local count=${#items[@]}
                # KDE creates this metadata file even on an empty desktop.
                if [[ "$dir_name" == desktop && -f "$dir/.directory" ]]; then
                    ((count -= 1))
                fi

                if ((count > 0)); then
                    report+=("🚧 $dir_name ($count)")
                else
                    report+=("✅ $dir_name")
                fi
            else
                report+=("❌ $dir_name")
            fi
        done

        local updates
        local update_count=0
        if ! updates=$(xbps-install -unM 2>/dev/null); then
            report+=("❔ updates (unable to check)")
        elif [[ -n "$updates" ]]; then
            update_count=$(print -r -- "$updates" | wc -l)
            report+=("🚧 updates ($update_count)")
        else
            report+=("✅ updates")
        fi

        local todo_file="$HOME/.cache/.pio_todo_list"
        local todo_count=0
        if [[ -f "$todo_file" ]]; then
            todo_count=$(wc -l <"$todo_file")
        fi

        if [ $todo_count -gt 0 ]; then
            report+=("🚧 todos ($todo_count)")
        else
            report+=("✅ todos")
        fi

        local -i security_failures=0
        local -i security_warnings=0
        local mullvad_ok=false
        local mullvad_status
        if command -v mullvad &>/dev/null &&
            mullvad_status=$(mullvad status 2>/dev/null) &&
            [[ "$mullvad_status" == Connected* ]]; then
            mullvad_ok=true
        fi

        if $mullvad_ok; then
            report+=("✅ mullvad")
        else
            report+=("❌ mullvad")
            ((security_failures += 1))
        fi

        if ! command -v ufw &>/dev/null; then
            report+=("❌ ufw")
            ((security_failures += 1))
        elif ! $ufw_checked; then
            report+=("❌ ufw")
            ((security_warnings += 1))
        elif [[ "$ufw_status" == *"Status: active"* ]]; then
            report+=("✅ ufw")
        elif [[ "$ufw_status" == *"Status: inactive"* ]]; then
            report+=("❌ ufw")
            ((security_failures += 1))
        else
            report+=("❌ ufw")
            ((security_warnings += 1))
        fi

        if command -v pgrep &>/dev/null; then
            local tailscale_result=0
            pgrep -x tailscaled &>/dev/null || tailscale_result=$?
            case "$tailscale_result" in
            0) report+=("🚧 tailscale (running)") ;;
            1) report+=("✅ tailscale (not running)") ;;
            *) report+=("❔ tailscale (unable to check)") ;;
            esac
        else
            report+=("❔ tailscale (pgrep not installed)")
        fi

        local ssh_server_running=false
        if command -v pgrep &>/dev/null && { pgrep -x sshd &>/dev/null || pgrep -x dropbear &>/dev/null; }; then
            ssh_server_running=true
        elif command -v ss &>/dev/null && [[ -n "$(ss -H -ltn 'sport = :22' 2>/dev/null)" ]]; then
            ssh_server_running=true
        fi

        if $ssh_server_running; then
            report+=("❌ ssh server (running)")
            ((security_failures += 1))
        elif command -v pgrep &>/dev/null || command -v ss &>/dev/null; then
            report+=("✅ ssh server (not running)")
        else
            report+=("❔ ssh server (unable to check)")
            ((security_warnings += 1))
        fi

        if ((security_failures > 0)); then
            report+=("🚨 unsafe ($security_failures failed, $security_warnings warnings)")
        elif ((security_warnings > 0)); then
            report+=("🚧 caution ($security_warnings warnings)")
        else
            report+=("🔐 safe")
        fi
    } always {
        if [[ -n "$spinner_pid" ]]; then
            kill "$spinner_pid" 2>/dev/null
            wait "$spinner_pid" 2>/dev/null
            printf '\r\033[2K' >&2
        fi
    }
    print -r -- "${(F)report}"
}

xsearch() {
    if $PIOBUNTU; then
        apt-cache pkgnames "$1" | sort -u | fzf --preview-window='bottom:45%:wrap' --preview 'apt-cache show {1}' | xargs -ro sudo apt install
    else
        xbps-query -Rs "$1" | sort -u | fzf --preview-window='bottom:45%:wrap' --preview 'xbps-query -Rv {2} ' | awk '{print $2}' | xargs -ro xi
    fi
}

xrm() {
    if $PIOBUNTU; then
        sudo apt-get autoremove $1
    else
        sudo xbps-remove -ROo $1 && flatpak uninstall --unused
    fi
}

xhold() {
    if [ -n "$1" ]; then
        sudo xbps-pkgdb -m hold $1
    else
        xpkg -H
    fi
}

xunhold() {
    sudo xbps-pkgdb -m unhold $1
}
