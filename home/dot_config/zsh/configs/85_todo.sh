#!/usr/bin/env zsh

export PIO_TODO_FILE="${PIO_TODO_FILE:-$HOME/sync/vault/.todos}"

_pio_todo_commit() {
    local action="$1" msg="$2"
    local todo_file="${PIO_TODO_FILE:A}"
    local prefix="todo: $action '"
    local max_msg_length=$((80 - ${#prefix} - 2))

    # Keep the headline on one line; leave the task itself unchanged.
    msg="${msg//$'\n'/ }"
    msg="${msg//$'\r'/ }"
    if (( ${#msg} > max_msg_length )); then
        msg="${msg[1,$((max_msg_length - 3))]}..."
    fi

    if ! git -C "${todo_file:h}" add -- "${todo_file:t}"; then
        printf 'Warning: Todo saved, but could not stage it for commit.\n' >&2
        return 1
    fi
    if git -C "${todo_file:h}" diff --cached --quiet -- "${todo_file:t}"; then
        return 0
    fi
    # --only excludes unrelated changes already staged in the repository.
    if ! git -C "${todo_file:h}" commit --only --quiet -m "${prefix}${msg}'." -- "${todo_file:t}"; then
        printf 'Warning: Todo saved, but not committed.\n' >&2
        return 1
    fi
}

todo() {
    local todo_file="$PIO_TODO_FILE"
    if ! mkdir -p "${todo_file:h}"; then
        printf 'Error: Cannot create todo directory: %s\n' "${todo_file:h}" >&2
        return 1
    fi
    if [[ ! -f "$todo_file" ]] && ! touch "$todo_file"; then
        printf 'Error: Cannot initialize todo file: %s\n' "$todo_file" >&2
        return 1
    fi

    case "$1" in
    add)
        shift
        if [[ -z "$*" ]]; then
            printf 'Error: Please provide a task to add.\n' >&2
            return 1
        fi
        if ! printf '%s\n' "$*" >>"$todo_file"; then
            printf 'Error: Could not add task to %s\n' "$todo_file" >&2
            return 1
        fi
        printf '\033[1;32m✔ Added:\033[0m %s\n' "$*"
        _pio_todo_commit Add "$*"
        ;;

    rm)
        local num="$2"
        if [[ ! "$num" =~ ^[0-9]+$ ]]; then
            printf 'Error: Please provide a valid task number (e.g., todo rm 1).\n' >&2
            return 1
        fi

        local removed
        if ! removed=$(awk -v n="$num" 'NR == n' "$todo_file"); then
            printf 'Error: Could not read %s\n' "$todo_file" >&2
            return 1
        fi
        if [[ -z "$removed" ]]; then
            printf 'Error: Task number %s does not exist.\n' "$num" >&2
            return 1
        fi

        if ! { awk -v n="$num" 'NR != n' "$todo_file" >"${todo_file}.tmp" && mv "${todo_file}.tmp" "$todo_file"; }; then
            printf 'Error: Could not remove task %s from %s\n' "$num" "$todo_file" >&2
            return 1
        fi
        printf '\033[1;31m✖ Removed:\033[0m %s\n' "$removed"
        _pio_todo_commit Remove "$removed"
        ;;

    list | "")
        if [[ ! -r "$todo_file" ]]; then
            printf 'Error: Could not read %s\n' "$todo_file" >&2
            return 1
        fi
        if [[ ! -s "$todo_file" ]]; then
            printf "\033[1;32m✨ No tasks! You're all caught up.\033[0m\n"
            return 0
        fi

        printf '\033[1;34m╭── TODO LIST\033[0m\n'
        local i=1
        while IFS= read -r line; do
            printf '\033[1;34m│\033[0m \033[1;33m[%s]\033[0m %s\n' "$i" "$line"
            ((i++))
        done <"$todo_file"
        printf '\033[1;34m╰────────────\033[0m\n'
        ;;

    *)
        printf '%s\n' 'Usage:' \
            '  todo add "task text"  - Add a new task' \
            "  todo list             - Show all tasks (or just 'todo')" \
            '  todo rm <number>      - Remove a task by its number'
        ;;
    esac
}

_pio_todo() {
    if (( CURRENT == 2 )); then
        local -a actions=(
            'add:Add a task'
            'list:Show all tasks'
            'rm:Remove a task'
        )
        _describe 'todo action' actions
    elif (( CURRENT == 3 )) && [[ "${words[2]}" == rm ]]; then
        local -a numbers descriptions
        local line
        local i=1
        [[ -r "$PIO_TODO_FILE" ]] || return 1
        while IFS= read -r line; do
            numbers+=("$i")
            descriptions+=("$i -- $line")
            ((i++))
        done <"$PIO_TODO_FILE"
        compadd -d descriptions -a numbers
    fi
}
