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
    note_file="$HOME/sync/vault/note_$(date +%Y%m%d%H%M%S).md"
    $EDITOR "$note_file"
}

pio_prompt() {
    local name="$1"
    local prompt_folder="$HOME/sync/brain/sessions/$name"

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

        # Read UFW and WireGuard while the sudo credentials are fresh.
        local ufw_status=""
        local ufw_checked=false
        if command -v ufw &>/dev/null; then
            if ufw_status=$(sudo -n env LC_ALL=C ufw status 2>/dev/null); then
                ufw_checked=true
            fi
        fi

        local wireguard_state=unknown
        local wireguard_interfaces=""
        local active_wireguard=()
        if command -v wg &>/dev/null &&
            wireguard_interfaces=$(sudo -n wg show interfaces 2>/dev/null); then
            wireguard_state=off
            local wireguard_interface
            for wireguard_interface in ${=wireguard_interfaces}; do
                # Mullvad's tunnel is part of the expected secure baseline.
                [[ "$wireguard_interface" == wg0-mullvad ]] && continue
                local wireguard_link=""
                if command -v ip &>/dev/null &&
                    wireguard_link=$(ip -o link show dev "$wireguard_interface" up 2>/dev/null); then
                    # An enabled tunnel counts even without recent traffic or handshakes.
                    [[ -n "$wireguard_link" ]] && active_wireguard+=("$wireguard_interface")
                else
                    wireguard_state=unknown
                fi
            done
            ((${#active_wireguard[@]} > 0)) && wireguard_state=on
        fi

        local is_void=false
        if [[ -r /etc/os-release ]] && [[ "$(. /etc/os-release; print -r -- "$ID")" == void ]]; then
            is_void=true
        fi

        local group repo sync_dir entry
        for group in dotfiles void sync; do
            local repos=()
            local dirs=()
            local issues=()
            local unable_to_check=false
            local missing_dir=false

            case "$group" in
            dotfiles)
                repos=("$HOME/.local/share/chezmoi")
                local chezmoi_status=""
                if ! chezmoi_status=$(chezmoi status 2>/dev/null); then
                    issues+=("unable to check unapplied changes")
                    unable_to_check=true
                elif [[ -n "$chezmoi_status" ]]; then
                    issues+=("unapplied changes")
                fi
                ;;
            void)
                $is_void || continue
                repos=("$HOME/3pp/void-packages")
                local updates=""
                if ! updates=$(xbps-install -unM 2>/dev/null); then
                    issues+=("unable to check updates")
                    unable_to_check=true
                elif [[ -n "$updates" ]]; then
                    local update_lines=("${(@f)updates}")
                    issues+=("updates (${#update_lines[@]})")
                fi
                ;;
            sync)
                repos=("$HOME/sync/vault" "$HOME/sync/brain")
                dirs=(
                    "$HOME/download:download"
                    "$HOME/.local/share/Trash/files:trash"
                    "$(xdg-user-dir DESKTOP 2>/dev/null):desktop"
                )
                for sync_dir in sync sync/picture sync/brain sync/vault; do
                    if [[ ! -d "$HOME/$sync_dir" ]]; then
                        issues+=("missing ~/$sync_dir")
                        missing_dir=true
                    fi
                done
                ;;
            esac

            for repo in "${repos[@]}"; do
                # Missing sync repositories are already reported as missing folders.
                if [[ "$group" == sync && ! -d "$repo" ]]; then
                    continue
                fi
                local prefix="${repo##*/} "
                [[ "$group" == dotfiles ]] && prefix=""
                local fetch_ok=true
                git -C "$repo" fetch --all --quiet &>/dev/null || fetch_ok=false

                local uncommitted=""
                local branch_status=""
                if ! uncommitted=$(git -C "$repo" status --porcelain 2>/dev/null) ||
                    ! branch_status=$(git -C "$repo" status -sb 2>/dev/null); then
                    issues+=("${prefix}unable to check git")
                    unable_to_check=true
                    continue
                fi

                $fetch_ok || issues+=("${prefix}fetch failed")
                [[ -n "$uncommitted" ]] && issues+=("${prefix}git changes")
                branch_status="${branch_status%%$'\n'*}"
                [[ "$branch_status" == *'[ahead '* ]] && issues+=("${prefix}needs push")
                if [[ "$branch_status" == *'[behind '* || "$branch_status" == *', behind '* ]]; then
                    issues+=("${prefix}needs pull")
                fi
            done

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
                    ((count > 0)) && issues+=("$dir_name ($count)")
                else
                    issues+=("missing $dir_name folder")
                    missing_dir=true
                fi
            done

            if ((${#issues[@]} == 0)); then
                report+=("✅ $group")
            else
                local emoji="🚧"
                $unable_to_check && emoji="❔"
                $missing_dir && emoji="❌"
                report+=("$emoji $group: ${(j:; :)issues}")
            fi
        done

        if [[ -d "$HOME/tmp" ]]; then
            local tmp_items=("$HOME/tmp"/*(ND))
            if ((${#tmp_items[@]} > 0)); then
                report+=("🚧 tmp (${#tmp_items[@]})")
            else
                report+=("✅ tmp")
            fi
        else
            report+=("❌ tmp")
        fi

        local todo_file="$PIO_TODO_FILE"
        local todo_count=0
        if [[ -f "$todo_file" ]]; then
            todo_count=$(wc -l <"$todo_file")
        fi

        if [ $todo_count -gt 0 ]; then
            report+=("🚧 todos ($todo_count)")
        else
            report+=("✅ todos")
        fi

        local mullvad_state=unknown
        local mullvad_status=""
        if command -v mullvad &>/dev/null && mullvad_status=$(mullvad status 2>/dev/null); then
            case "$mullvad_status" in
            Connected*) mullvad_state=on ;;
            Disconnected* | Connecting* | Disconnecting*) mullvad_state=off ;;
            esac
        fi

        local ufw_state=unknown
        if $ufw_checked; then
            case "$ufw_status" in
            *"Status: active"*) ufw_state=on ;;
            *"Status: inactive"*) ufw_state=off ;;
            esac
        fi

        local -A service_states=(tailscaled unknown sshd unknown dropbear unknown)
        local service
        if command -v pgrep &>/dev/null; then
            for service in tailscaled sshd dropbear; do
                local service_result=0
                pgrep -x "$service" &>/dev/null || service_result=$?
                case "$service_result" in
                0) service_states[$service]=on ;;
                1) service_states[$service]=off ;;
                esac
            done
        fi

        local tailscale_state="${service_states[tailscaled]}"
        local ssh_state=unknown
        if [[ "${service_states[sshd]}" == on || "${service_states[dropbear]}" == on ]]; then
            ssh_state=on
        elif [[ "${service_states[sshd]}" == off && "${service_states[dropbear]}" == off ]]; then
            ssh_state=off
        fi
        if [[ "$ssh_state" != on ]] && command -v ss &>/dev/null; then
            local ssh_listeners=""
            if ssh_listeners=$(ss -H -ltn 'sport = :22' 2>/dev/null) && [[ -n "$ssh_listeners" ]]; then
                ssh_state=on
            fi
            # An empty port 22 cannot rule out SSH on another port if pgrep failed.
        fi

        local security_details=()
        case "$ufw_state" in
        off) security_details+=("UFW off") ;;
        unknown) security_details+=("UFW status unknown") ;;
        esac
        case "$mullvad_state" in
        off) security_details+=("Mullvad not connected") ;;
        unknown) security_details+=("Mullvad status unknown") ;;
        esac
        case "$tailscale_state" in
        on) security_details+=("Tailscale running") ;;
        unknown) security_details+=("Tailscale status unknown") ;;
        esac
        case "$ssh_state" in
        on) security_details+=("SSH running") ;;
        unknown) security_details+=("SSH status unknown") ;;
        esac
        case "$wireguard_state" in
        on) security_details+=("WireGuard active: ${(j:, :)active_wireguard}") ;;
        unknown) security_details+=("WireGuard status unknown") ;;
        esac

        # Prioritize known concerns, then incomplete checks, then the desired baseline.
        local security_emoji="🔒"
        local security_level="baseline met"
        if [[ "$wireguard_state" == on ||
            ( "$ufw_state" == off && ( "$tailscale_state" == on || "$ssh_state" == on ) ) ]]; then
            security_emoji="🚨"
            security_level="review exposure"
        elif [[ "$ufw_state" == off || "$mullvad_state" == off ]]; then
            security_emoji="🚧"
            security_level="reduced protection"
        elif [[ "$ufw_state" == unknown || "$mullvad_state" == unknown ||
            "$tailscale_state" == unknown || "$ssh_state" == unknown || "$wireguard_state" == unknown ]]; then
            security_emoji="❔"
            security_level="incomplete checks"
        elif [[ "$tailscale_state" == on || "$ssh_state" == on ]]; then
            security_emoji="👀"
            security_level="remote services"
        fi

        local security_line="$security_emoji Security: $security_level"
        ((${#security_details[@]} > 0)) && security_line+=" (${(j:; :)security_details})"
        report+=("$security_line")
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
