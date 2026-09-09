#!/bin/zsh

# Zsh prompt with a single Git status query per refresh.

autoload -Uz add-zsh-hook
zmodload zsh/datetime

setopt prompt_subst

# Left prompt
# %3~ truncates the directory path to the last 3 segments, similar to Starship's default.
PROMPT="%B%F{cyan}%3~%f%b "
PROMPT2="▶▶ "

function _prompt_preexec() {
    __timer=${EPOCHREALTIME}
}

function _format_duration() {
    local duration=$1
    if ((duration < 0.001)); then
        printf "0ms"
    elif ((duration < 1)); then
        local ms=$((duration * 1000))
        printf "%.0fms" $ms
    elif ((duration < 60)); then
        printf "%.1fs" $duration
    else
        # 'local -i' forces integer type, safely casting the float
        # Adding 0.5 ensures proper rounding before we extract minutes/seconds
        local -i total_sec=$((duration + 0.5))

        local -i h=$((total_sec / 3600))
        local -i m=$(((total_sec % 3600) / 60))
        local -i s=$((total_sec % 60))

        if ((h > 0)); then
            printf "%dh%dm%ds" $h $m $s
        else
            printf "%dm%ds" $m $s
        fi
    fi
}

function _prompt_precmd() {
    local exit_code=$?

    # Calculate command duration
    local duration_str=""
    if [[ -n $__timer ]]; then
        local now=${EPOCHREALTIME}
        local duration=$((now - __timer))
        duration_str="%B%F{yellow}$(_format_duration $duration)%f%b"
        unset __timer
    fi

    # Git Information
    local git_branch_str=""
    local git_status_str=""
    local git_state_str=""

    local status_out
    if status_out=$(git --no-optional-locks status --porcelain=v2 --branch --show-stash 2>/dev/null); then
        local branch="" line x y ab_out
        local conflicted=0 ahead=0 behind=0 untracked=0 stashed=0 modified=0 staged=0 renamed=0 deleted=0

        # Porcelain v2 includes branch, divergence and stash counts alongside files.
        # Only inspect record prefixes; filenames may contain spaces or escapes.
        while IFS= read -r line; do
            case "$line" in
                '# branch.head '*) branch=${line#\# branch.head } ;;
                '# branch.ab '*)
                    ab_out=${line#\# branch.ab }
                    ahead=${${ab_out%% *}#+}
                    behind=${${ab_out##* }#-}
                    ;;
                '# stash '*) stashed=${line#\# stash } ;;
                'u '*) conflicted=$((conflicted + 1)) ;;
                '? '*) untracked=$((untracked + 1)) ;;
                '1 '*|'2 '*)
                    x=${line[3]}
                    y=${line[4]}
                    if [[ $x == M || $y == M ]]; then modified=$((modified + 1)); fi
                    if [[ $x == A || $x == C ]]; then staged=$((staged + 1)); fi
                    if [[ $x == R ]]; then renamed=$((renamed + 1)); fi
                    if [[ $x == D || $y == D ]]; then deleted=$((deleted + 1)); fi
                    ;;
            esac
        done <<<"$status_out"

        if [[ $branch == '(detached)' ]]; then
            branch=$(git rev-parse --short HEAD 2>/dev/null)
        fi
        # A literal percent in a branch name must not become a prompt escape.
        git_branch_str="%B%F{magenta}[ ${branch//\%/%%}]%f%b"

        local status_components=()
        if ((conflicted > 0)); then status_components+=("󰞇${conflicted}"); fi

        if ((ahead > 0 && behind > 0)); then
            status_components+=("⇕⇡${ahead}⇣${behind}")
        elif ((ahead > 0)); then
            status_components+=("⇡${ahead}")
        elif ((behind > 0)); then status_components+=("⇣${behind}"); fi

        if ((stashed > 0)); then status_components+=("*${stashed}"); fi
        if ((modified > 0)); then status_components+=("!${modified}"); fi
        if ((staged > 0)); then status_components+=("+${staged}"); fi
        if ((renamed > 0)); then status_components+=(">${renamed}"); fi
        if ((deleted > 0)); then status_components+=("x${deleted}"); fi
        if ((untracked > 0)); then status_components+=("?${untracked}"); fi

        if ((${#status_components[@]} > 0)); then
            local git_status_joined=${(j: :)status_components}
            git_status_str="%B%F{yellow}[${git_status_joined}]%f%b"
        fi

        # Git State (rebasing, merging, etc.)
        local git_dir=$(git rev-parse --git-dir 2>/dev/null)
        if [[ -d "$git_dir/rebase-merge" || -d "$git_dir/rebase-apply" ]]; then
            git_state_str="%B%F{yellow}(REBASING)%f%b"
        elif [[ -f "$git_dir/MERGE_HEAD" ]]; then
            git_state_str="%B%F{yellow}(MERGING)%f%b"
        elif [[ -f "$git_dir/CHERRY_PICK_HEAD" ]]; then
            git_state_str="%B%F{yellow}(CHERRY-PICKING)%f%b"
        elif [[ -f "$git_dir/REVERT_HEAD" ]]; then
            git_state_str="%B%F{yellow}(REVERTING)%f%b"
        elif [[ -f "$git_dir/BISECT_LOG" ]]; then
            git_state_str="%B%F{yellow}(BISECTING)%f%b"
        fi

    fi

    # Character (Success/Error)
    local character="%(?.%B%F{green}󰗠%f%b.%B%F{red}󰅙%f%b)"

    # Time
    local time_str="%B%F{yellow}[%D{%T}]%f%b"

    # Assemble right prompt: $git_branch$git_status$git_state$character$cmd_duration$time
    local rprompt_parts=()
    if [[ -n $git_branch_str ]]; then
        local combined_git="${git_branch_str}"
        [[ -n $git_status_str ]] && combined_git="${combined_git}${git_status_str}"
        [[ -n $git_state_str ]] && combined_git="${combined_git}${git_state_str}"
        rprompt_parts+=("${combined_git}")
    fi

    rprompt_parts+=("${character}")
    [[ -n $duration_str ]] && rprompt_parts+=("${duration_str}")
    rprompt_parts+=("${time_str}")

    RPROMPT="${(j: :)rprompt_parts}"
}

add-zsh-hook precmd _prompt_precmd
add-zsh-hook preexec _prompt_preexec
