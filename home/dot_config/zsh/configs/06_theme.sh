#!/usr/bin/env bash

detect_theme() {
    if ! pio_helper_check_command plasma-apply-colorscheme; then
        print -r -- dark
        return 0
    fi

    # KDE Plasma
    local kde_config="${XDG_CONFIG_HOME:-$HOME/.config}/kdeglobals"
    local cache_file="${XDG_CACHE_HOME:-$HOME/.cache}/zsh/pio-theme"
    local -A config_stat
    local cache_key="$kde_config:missing" cached_key cached_theme
    zmodload zsh/stat
    if zstat -H config_stat "$kde_config" 2>/dev/null; then
        cache_key="$kde_config:${config_stat[inode]}:${config_stat[size]}:${config_stat[mtime]}:${config_stat[ctime]}"
    fi

    # Recheck periodically for changes to system-wide KDE defaults, too.
    local -a fresh_cache=("$cache_file"(Nmh-20))
    if (( ${#fresh_cache} )); then
        if {
            IFS= read -r cached_key &&
                IFS= read -r cached_theme
            } < "$cache_file" 2>/dev/null &&
                [[ "$cached_key" == "$cache_key" && "$cached_theme" == (light|dark) ]]; then
            print -r -- "$cached_theme"
            return
        fi
    fi

    local theme_list
    if ! theme_list=$(plasma-apply-colorscheme -l 2>/dev/null); then
        # A transient display/session failure must not poison the cache.
        print -r -- dark
        return
    fi
    local current_theme
    current_theme=$(echo "$theme_list" | grep -E '\*.*current' | sed 's/\*//g' | awk '{print $1}')

    local theme=dark
    if [[ "$current_theme" =~ [Ll]ight ]]; then
        theme=light
    fi

    # Publish atomically so concurrent shells never read a partial entry.
    local cache_tmp="$cache_file.$$.$RANDOM"
    if mkdir -p "${cache_file:h}" 2>/dev/null; then
        if (umask 077; printf '%s\n%s\n' "$cache_key" "$theme" > "$cache_tmp") 2>/dev/null; then
            command mv -f -- "$cache_tmp" "$cache_file" 2>/dev/null || command rm -f -- "$cache_tmp"
        fi
    fi

    print -r -- "$theme"
}

setup_theme() {
    local initial_fzf_default_opts="$FZF_DEFAULT_OPTS"
    local theme
    theme=$(detect_theme) || theme=dark
    export PIO_THEME=$theme
    if [[ "$theme" == "light" ]]; then
        export FZF_DEFAULT_OPTS="$initial_fzf_default_opts \
      --highlight-line \
      --info=inline-right \
      --ansi \
      --layout=reverse \
      --border=none \
      --color=bg+:#ebebeb \
      --color=bg:#faf9f5 \
      --color=border:#000000 \
      --color=fg:#3d3d3d \
      --color=fg+:#000000 \
      --color=gutter:#faf9f5 \
      --color=header:#000000 \
      --color=hl+:#b07700 \
      --color=hl:#b07700 \
      --color=info:#969ba5 \
      --color=marker:#ca0043 \
      --color=pointer:#000000 \
      --color=prompt:#000000 \
      --color=query:#101010:regular \
      --color=scrollbar:#000000 \
      --color=separator:#000000 \
      --color=spinner:#969ba5 \
      "
    else
        export FZF_DEFAULT_OPTS="$initial_fzf_default_opts \
      --highlight-line \
      --info=inline-right \
      --ansi \
      --layout=reverse \
      --border=none \
      --color=bg+:#272727 \
      --color=bg:#000000 \
      --color=border:#ffffff \
      --color=fg:#b0b0b0 \
      --color=fg+:#ffffff \
      --color=gutter:#101010 \
      --color=header:#ffffff \
      --color=hl+:#d9ba73 \
      --color=hl:#d9ba73 \
      --color=info:#50585d \
      --color=marker:#ff7676 \
      --color=pointer:#ffffff \
      --color=prompt:#ffffff \
      --color=query:#b0b0b0:regular \
      --color=scrollbar:#b0b0b0 \
      --color=separator:#ffffff \
      --color=spinner:#50585d \
      "
    fi

    shell-greet
}
