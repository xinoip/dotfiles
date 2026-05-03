#!/bin/zsh

function todo() {
    local todo_file="$HOME/.cache/.pio_todo_list"
    [[ -f "$todo_file" ]] || touch "$todo_file"

    case "$1" in
    add)
        shift
        if [[ -z "$*" ]]; then
            echo "Error: Please provide a task to add."
            return 1
        fi
        echo "$*" >>"$todo_file"
        echo -e "\033[1;32m✔ Added:\033[0m $*"
        ;;

    rm)
        local num="$2"
        if [[ ! "$num" =~ ^[0-9]+$ ]]; then
            echo "Error: Please provide a valid task number (e.g., todo rm 1)."
            return 1
        fi

        local removed=$(awk -v n="$num" 'NR == n' "$todo_file")
        if [[ -z "$removed" ]]; then
            echo "Error: Task number $num does not exist."
            return 1
        fi

        awk -v n="$num" 'NR != n' "$todo_file" >"${todo_file}.tmp" && mv "${todo_file}.tmp" "$todo_file"
        echo -e "\033[1;31m✖ Removed:\033[0m $removed"
        ;;

    list | "")
        if [[ ! -s "$todo_file" ]]; then
            echo -e "\033[1;32m✨ No tasks! You're all caught up.\033[0m"
            return 0
        fi

        echo -e "\033[1;34m╭── TODO LIST\033[0m"
        local i=1
        while IFS= read -r line; do
            echo -e "\033[1;34m│\033[0m \033[1;33m[$i]\033[0m $line"
            ((i++))
        done <"$todo_file"
        echo -e "\033[1;34m╰────────────\033[0m"
        ;;

    *)
        echo "Usage:"
        echo "  todo add \"task text\"  - Add a new task"
        echo "  todo list             - Show all tasks (or just 'todo')"
        echo "  todo rm <number>      - Remove a task by its number"
        ;;
    esac
}
