#!/bin/zsh

# Native replacement for mfaerevaag/wd to reduce attack surface.
# It uses ~/.cache/.warprc (or $WD_CONFIG) to store mappings.

wd() {
    local rcfile="${WD_CONFIG:-$HOME/.cache/.warprc}"
    [[ ! -f "$rcfile" ]] && touch "$rcfile"

    case "$1" in
        add)
            local name="${2:-$(basename "$PWD")}"
            # Remove existing entry if any
            local tmpfile=$(mktemp)
            grep -v "^${name}:" "$rcfile" > "$tmpfile"
            echo "${name}:${PWD}" >> "$tmpfile"
            mv "$tmpfile" "$rcfile"
            echo "Warp point '$name' added."
            ;;
        rm)
            local name="$2"
            if grep -q "^${name}:" "$rcfile"; then
                local tmpfile=$(mktemp)
                grep -v "^${name}:" "$rcfile" > "$tmpfile"
                mv "$tmpfile" "$rcfile"
                echo "Warp point '$name' removed."
            else
                echo "Warp point '$name' not found."
            fi
            ;;
        ls)
            if [[ -s "$rcfile" ]]; then
                printf "%-15s  %s\n" "ALIAS" "PATH"
                printf "%-15s  %s\n" "-----" "----"
                while IFS=: read -r name path; do
                    printf "\e[32m%-15s\e[0m  %s\n" "$name" "$path"
                done < "$rcfile"
            else
                echo "No warp points found."
            fi
            ;;
        help|--help|-h|"")
            echo "Usage: wd [add <name>|rm <name>|ls|<name>]"
            echo "  add [name]  Add current directory as [name] (defaults to folder name)"
            echo "  rm <name>   Remove warp point <name>"
            echo "  ls          List all warp points"
            echo "  <name>      Jump to warp point <name>"
            ;;
        *)
            local target=$(grep "^$1:" "$rcfile" | cut -d':' -f2-)
            if [[ -n "$target" ]]; then
                cd "$target"
            else
                echo "Warp point '$1' not found."
                return 1
            fi
            ;;
    esac
}

# Simple completion for wd
_wd() {
    local rcfile="${WD_CONFIG:-$HOME/.cache/.warprc}"
    local -a commands points
    commands=(add rm ls help)
    if [[ -f "$rcfile" ]]; then
        points=($(cut -d':' -f1 "$rcfile"))
    fi
    _arguments '1: :->cmds_or_points'
    case "$state" in
        cmds_or_points)
            _values 'commands and points' $commands $points
            ;;
    esac
}
compdef _wd wd
