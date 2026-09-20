#!/usr/bin/env zsh

export PIO_WD_FILE="${PIO_WD_FILE:-$HOME/vault/.warp_dirs}"

_pio_wd_commit() {
    local action="$1" name="$2"
    local file="${PIO_WD_FILE:A}"
    local prefix="wd: $action '"
    local max_name_length=$((80 - ${#prefix} - 2))
    if (( ${#name} > max_name_length )); then
        name="${name[1,$((max_name_length - 3))]}..."
    fi
    if ! git -C "${file:h}" add -- "${file:t}"; then
        printf 'wd: bookmark saved, but could not stage it for commit.\n' >&2
        return 1
    fi
    if git -C "${file:h}" diff --cached --quiet -- "${file:t}"; then
        return 0
    fi
    if ! git -C "${file:h}" commit --only --quiet -m "${prefix}${name}'." -- "${file:t}"; then
        printf 'wd: bookmark saved, but not committed.\n' >&2
        return 1
    fi
}

wd() {
    local file="$PIO_WD_FILE"
    local action="${1:-list}" arg="${2:-}"
    if ! mkdir -p "${file:h}"; then
        printf 'wd: cannot create directory: %s\n' "${file:h}" >&2
        return 1
    fi
    if [[ ! -e "$file" ]] && ! touch "$file"; then
        printf 'wd: cannot create bookmark file: %s\n' "$file" >&2
        return 1
    fi
    if [[ ! -f "$file" || ! -r "$file" ]]; then
        printf 'wd: cannot read bookmark file: %s\n' "$file" >&2
        return 1
    fi

    local contents
    if ! contents=$(cat -- "$file"); then
        printf 'wd: cannot read bookmark file: %s\n' "$file" >&2
        return 1
    fi
    local -a entries=()
    [[ -n "$contents" ]] && entries=("${(@f)contents}")
    local entry name target_dir

    case "$action" in
    add)
        name="${arg:-${PWD:t}}"
        if [[ -z "$name" || "$name" == *[[:space:]]* || "$name" == (add|rm|list) ]]; then
            printf 'wd: name must be nonempty, contain no whitespace, and not be add, rm, or list.\n' >&2
            return 1
        fi
        if [[ "$PWD" == *$'\n'* || "$PWD" == *$'\r'* ]]; then
            printf 'wd: directory paths cannot contain line breaks.\n' >&2
            return 1
        fi
        for entry in "${entries[@]}"; do
            if [[ "${entry%% *}" == "$name" ]]; then
                printf "wd: bookmark '%s' already exists. Remove it first.\n" "$name" >&2
                return 1
            fi
        done
        if ! printf '%s %s\n' "$name" "$PWD" >>"$file"; then
            printf 'wd: could not add bookmark: %s\n' "$name" >&2
            return 1
        fi
        _pio_wd_commit Add "$name"
        ;;
    rm)
        if [[ -z "$arg" ]]; then
            printf 'Usage: wd rm <name>\n' >&2
            return 1
        fi
        local -a remaining=()
        local found=false
        for entry in "${entries[@]}"; do
            if [[ "${entry%% *}" == "$arg" ]]; then
                found=true
            else
                remaining+=("$entry")
            fi
        done
        if [[ "$found" == false ]]; then
            printf 'wd: unknown bookmark: %s\n' "$arg" >&2
            return 1
        fi
        if ! ( for entry in "${remaining[@]}"; do printf '%s\n' "$entry" || exit 1; done ) >"${file}.tmp"; then
            printf 'wd: could not write updated bookmarks.\n' >&2
            return 1
        fi
        if ! mv -- "${file}.tmp" "$file"; then
            printf 'wd: could not remove bookmark: %s\n' "$arg" >&2
            return 1
        fi
        _pio_wd_commit Remove "$arg"
        ;;
    list | "")
        local width=0
        for entry in "${entries[@]}"; do
            name="${entry%% *}"
            (( ${#name} > width )) && width=${#name}
        done
        for entry in "${entries[@]}"; do
            printf '%-*s  %s\n' "$width" "${entry%% *}" "${entry#* }"
        done
        ;;
    *)
        for entry in "${entries[@]}"; do
            if [[ "${entry%% *}" == "$action" ]]; then
                target_dir="${entry#* }"
                if [[ ! -d "$target_dir" ]]; then
                    printf 'wd: bookmark directory does not exist: %s\n' "$target_dir" >&2
                    return 1
                fi
                builtin cd -- "$target_dir"
                return $?
            fi
        done
        printf 'wd: unknown bookmark: %s\n' "$action" >&2
        return 1
        ;;
    esac
}

_pio_wd() {
    local -a names=() descriptions=()
    local entry name
    if (( CURRENT == 2 )); then
        names=(add rm list)
        descriptions=('add -- Save current directory' 'rm -- Remove a bookmark' 'list -- List bookmarks')
    elif ! (( CURRENT == 3 )) || [[ "${words[2]}" != rm ]]; then
        return 1
    fi
    if [[ -f "$PIO_WD_FILE" && -r "$PIO_WD_FILE" ]]; then
        while IFS= read -r entry || [[ -n "$entry" ]]; do
            [[ -n "$entry" ]] || continue
            name="${entry%% *}"
            names+=("$name")
            descriptions+=("$name -- ${entry#* }")
        done <"$PIO_WD_FILE"
    fi
    compadd -d descriptions -a names
}
