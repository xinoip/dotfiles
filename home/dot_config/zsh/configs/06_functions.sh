#!/usr/bin/env bash

pio_confirm() {
    local -r MSG="$1"
    read -q "?$MSG (y/N) "
    local ok=$?
    printf "\n"
    return $ok
}

docker_prune_all() {
    docker container prune
    docker volume prune -a
    docker image prune -a
    docker network prune
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

note() {
    local note_file
    note_file="$HOME/tmp/note_$(date +%Y%m%d%H%M%S).md"
    $EDITOR "$note_file"
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
        pio_confirm "Update Ubuntu?" && sudo apt update && sudo apt upgrade && echo "Ubuntu updated."
    else
        pio_confirm "Update Void?" &&
            xi -Su &&
            cd $HOME/3pp/void-packages &&
            ./personal/update.sh &&
            echo "Void updated."
    fi

    if [[ -f /usr/bin/flatpak ]]; then
        pio_confirm "Update Flatpak?" && flatpak update && echo "Flatpak updated."
    fi
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

pio_toggle_sshd() {
    if $PIOBUNTU; then
        echo "Toggling sshd not supported on Ubuntu for now."
    else
        if [ -L /var/service/sshd ]; then
            echo "Disabling sshd..."
            sudo delf /var/service/sshd
        else
            echo "Enabling sshd..."
            sudo ln -s /etc/sv/sshd /var/service
        fi
    fi
}

pio_status() {
    local repos=(
        "$HOME/dotfiles"
        "$HOME/repo/notes"
        "$HOME/3pp/void-packages"
        "$HOME/sync/vault"
    )

    for repo in "${repos[@]}"; do
        git -C "$repo" fetch --all

        local reponame=${repo##*/}
        local uncommitted=$(git -C "$repo" status --porcelain)
        local branch_status=$(git -C "$repo" status -sb)

        local needs_commit=false
        local needs_push=false
        local needs_pull=false

        [[ -n "$uncommitted" ]] && needs_commit=true
        [[ "$branch_status" == *"ahead"* ]] && needs_push=true
        [[ "$branch_status" == *"behind"* ]] && needs_pull=true

        if ! $needs_commit && ! $needs_push && ! $needs_pull; then
            echo "✅ $reponame"
        else
            echo "⚠️ $reponame"
        fi
    done

    local dirs=(
        "$HOME/tmp:tmp"
        "$HOME/download:download"
        "$HOME/.local/share/Trash/files:trash"
        "$(xdg-user-dir DESKTOP):desktop"
    )

    for entry in "${dirs[@]}"; do
        local dir="${entry%:*}"
        local dir_name="${entry##*:}"

        if [[ -d "$dir" ]]; then
            local items=("$dir"/*(ND))
            local count=${#items[@]}

            if ((count > 0)); then
                echo "⚠️ $dir_name ($count)"
            else
                echo "✅ $dir_name"
            fi
        else
            echo "❌ $dir_name"
        fi
    done

    local update_count=$(xbps-install -unM | wc -l)

    if [ $update_count -gt 0 ]; then
        echo "⚠️ updates ($update_count)"
    else
        echo "✅ updates"
    fi

    local todo_file="$HOME/.cache/.pio_todo_list"
    local todo_count=0
    if [[ -f "$todo_file" ]]; then
        todo_count=$(wc -l <"$todo_file")
    fi

    if [ $todo_count -gt 0 ]; then
        echo "⚠️ todos ($todo_count)"
    else
        echo "✅ todos"
    fi

    local -i security_failures=0
    local -i security_warnings=0
    local mullvad_connected=false

    if command -v mullvad &>/dev/null; then
        local mullvad_status=$(mullvad status 2>/dev/null)

        case "$mullvad_status" in
        Connected*)
            echo "✅ mullvad (connected)"
            mullvad_connected=true
            ;;
        Disconnected*)
            echo "❌ mullvad (disconnected)"
            ((security_failures += 1))
            ;;
        Connecting* | Disconnecting*)
            echo "❌ mullvad (${${mullvad_status%%$'\n'*}:l})"
            ((security_failures += 1))
            ;;
        *)
            echo "❌ mullvad (not running)"
            ((security_failures += 1))
            ;;
        esac
    else
        echo "❌ mullvad (not installed)"
        ((security_failures += 1))
    fi

    if $mullvad_connected; then
        if command -v curl &>/dev/null; then
            local mullvad_external
            if mullvad_external=$(curl -fsS --max-time 5 https://am.i.mullvad.net/connected 2>/dev/null); then
                if [[ "$mullvad_external" == "You are connected to Mullvad"* ]]; then
                    echo "✅ mullvad route (verified)"
                else
                    echo "❌ mullvad route (not using Mullvad)"
                    ((security_failures += 1))
                fi
            else
                echo "❔ mullvad route (unable to verify)"
                ((security_warnings += 1))
            fi
        else
            echo "❔ mullvad route (curl not installed)"
            ((security_warnings += 1))
        fi

        local lockdown_status
        if lockdown_status=$(mullvad lockdown-mode get 2>/dev/null); then
            if [[ "${lockdown_status:l}" == *on ]]; then
                echo "✅ mullvad lockdown (on)"
            else
                echo "⚠️ mullvad lockdown (off)"
                ((security_warnings += 1))
            fi
        else
            echo "❔ mullvad lockdown (unable to check)"
            ((security_warnings += 1))
        fi

        local lan_status
        if lan_status=$(mullvad lan get 2>/dev/null); then
            if [[ "${lan_status:l}" == *allow* ]]; then
                echo "⚠️ mullvad LAN sharing (allowed)"
                ((security_warnings += 1))
            else
                echo "✅ mullvad LAN sharing (blocked)"
            fi
        else
            echo "❔ mullvad LAN sharing (unable to check)"
            ((security_warnings += 1))
        fi

        local dns_status
        if dns_status=$(mullvad dns get 2>/dev/null); then
            if [[ "$dns_status" == *"Custom DNS: no"* ]]; then
                echo "✅ mullvad DNS (managed)"
            elif [[ "$dns_status" == *"Custom DNS: yes"* ]]; then
                echo "⚠️ mullvad DNS (custom resolver)"
                ((security_warnings += 1))
            else
                echo "❔ mullvad DNS (unable to determine)"
                ((security_warnings += 1))
            fi
        else
            echo "❔ mullvad DNS (unable to check)"
            ((security_warnings += 1))
        fi

        local split_status
        if split_status=$(mullvad split-tunnel list 2>/dev/null); then
            local split_pids="${split_status#*:}"
            if [[ -n "${split_pids//[[:space:]]/}" ]]; then
                echo "⚠️ mullvad split tunnel (processes excluded)"
                ((security_warnings += 1))
            else
                echo "✅ mullvad split tunnel (none)"
            fi
        else
            echo "❔ mullvad split tunnel (unable to check)"
            ((security_warnings += 1))
        fi
    fi

    local ufw_active=false
    if command -v ufw &>/dev/null; then
        local ufw_status
        if ufw_status=$(sudo ufw status verbose 2>/dev/null); then
            if [[ "$ufw_status" == *"Status: active"* ]]; then
                echo "✅ ufw (active)"
                ufw_active=true
            else
                echo "❌ ufw (inactive)"
                ((security_failures += 1))
            fi

            if $ufw_active; then
                if [[ "$ufw_status" == *"deny (incoming)"* || "$ufw_status" == *"reject (incoming)"* ]]; then
                    echo "✅ ufw incoming (default deny)"
                else
                    echo "❌ ufw incoming (permissive default)"
                    ((security_failures += 1))
                fi

                local broad_ufw_rules=$(print -r -- "$ufw_status" | awk '$2 ~ /^ALLOW/ && /Anywhere/')
                if [[ -n "$broad_ufw_rules" ]]; then
                    echo "⚠️ ufw rules (broad allow rule)"
                    ((security_warnings += 1))
                else
                    echo "✅ ufw rules (no broad allow rules)"
                fi
            fi
        else
            echo "❔ ufw (unable to check)"
            ((security_warnings += 1))
        fi
    else
        echo "❌ ufw (not installed)"
        ((security_failures += 1))
    fi

    local wifi_interfaces=(/sys/class/net/*/wireless(N))
    if ((${#wifi_interfaces[@]} > 0)); then
        if command -v nmcli &>/dev/null; then
            local nm_devices
            if nm_devices=$(nmcli -t -f TYPE,STATE device status 2>/dev/null); then
                if print -r -- "$nm_devices" | grep -qx 'wifi:connected'; then
                    local wifi_security=$(nmcli -t --escape no -f IN-USE,SECURITY device wifi list --rescan no 2>/dev/null |
                        awk -F: '$1 == "*" { sub(/^\*:/, ""); print; exit }')

                    if [[ -z "$wifi_security" || "$wifi_security" == "--" ]]; then
                        echo "⚠️ wifi (open network)"
                        ((security_warnings += 1))
                    else
                        echo "✅ wifi ($wifi_security)"
                    fi
                else
                    echo "✅ wifi (not connected)"
                fi
            else
                echo "❔ wifi (unable to check)"
                ((security_warnings += 1))
            fi
        elif command -v iw &>/dev/null; then
            local wifi_connected=false
            local wifi_path
            for wifi_path in "${wifi_interfaces[@]}"; do
                if iw dev "${wifi_path:h:t}" link 2>/dev/null | grep -q '^Connected to '; then
                    wifi_connected=true
                    break
                fi
            done

            if $wifi_connected; then
                echo "❔ wifi (connected, encryption unknown)"
                ((security_warnings += 1))
            else
                echo "✅ wifi (not connected)"
            fi
        else
            echo "❔ wifi (unable to check)"
            ((security_warnings += 1))
        fi
    fi

    if command -v ss &>/dev/null; then
        local exposed_listeners=$(ss -H -lntu 2>/dev/null |
            awk '$5 !~ /^127\./ && $5 !~ /^\[?::1\]?:/ { print $1, $5 }' |
            sort -u)

        if [[ -n "$exposed_listeners" ]]; then
            local listener_count=$(print -r -- "$exposed_listeners" | wc -l)
            echo "⚠️ network listeners ($listener_count non-loopback)"
            ((security_warnings += 1))
        else
            echo "✅ network listeners (none)"
        fi
    else
        echo "❔ network listeners (ss not installed)"
        ((security_warnings += 1))
    fi

    local ssh_server_running=false
    if command -v pgrep &>/dev/null && { pgrep -x sshd &>/dev/null || pgrep -x dropbear &>/dev/null; }; then
        ssh_server_running=true
    elif command -v ss &>/dev/null && [[ -n "$(ss -H -ltn 'sport = :22' 2>/dev/null)" ]]; then
        ssh_server_running=true
    fi

    if $ssh_server_running; then
        echo "❌ ssh server (running)"
        ((security_failures += 1))
    elif command -v pgrep &>/dev/null || command -v ss &>/dev/null; then
        echo "✅ ssh server (not running)"
    else
        echo "❔ ssh server (unable to check)"
        ((security_warnings += 1))
    fi

    if ((security_failures > 0)); then
        echo "🚨 unsafe ($security_failures failed, $security_warnings warnings)"
    elif ((security_warnings > 0)); then
        echo "⚠️ caution ($security_warnings warnings)"
    else
        echo "🛡️ safe"
    fi
}
