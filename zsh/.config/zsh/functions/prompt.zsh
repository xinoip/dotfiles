#!/bin/zsh

# AI GENERATED

# Pure Zsh Implementation of the configured Starship Prompt

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
    if (( duration < 0.001 )); then
        printf "0ms"
    elif (( duration < 1 )); then
        local ms=$(( duration * 1000 ))
        printf "%.0fms" $ms
    elif (( duration < 60 )); then
        printf "%.1fs" $duration
    else
        local m=$(( int(duration / 60) ))
        local s=$(( duration - (m * 60) ))
        printf "%dm%.0fs" $m $s
    fi
}

function _prompt_precmd() {
    local exit_code=$?

    # Calculate command duration
    local duration_str=""
    if [[ -n $__timer ]]; then
        local now=${EPOCHREALTIME}
        local duration=$(( now - __timer ))
        duration_str="%B%F{yellow}$(_format_duration $duration)%f%b"
        unset __timer
    fi

    # Git Information
    local git_branch_str=""
    local git_status_str=""
    local git_state_str=""

    if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
        local branch=$(git branch --show-current 2>/dev/null)
        if [[ -z $branch ]]; then
            branch=$(git rev-parse --short HEAD 2>/dev/null)
        fi
        # Starship bold purple color for branch
        git_branch_str="%B%F{magenta}[ ${branch}]%f%b"

        # Git Status
        local conflicted=0 ahead=0 behind=0 untracked=0 stashed=0 modified=0 staged=0 renamed=0 deleted=0
        
        local status_out=$(git status --porcelain 2>/dev/null)
        
        while IFS= read -r line; do
            if [[ -z $line ]]; then continue; fi
            local x=${line:0:1}
            local y=${line:1:1}
            
            if [[ $x == "U" || $y == "U" || ($x == "A" && $y == "A") || ($x == "D" && $y == "D") ]]; then
                conflicted=$((conflicted + 1))
            else
                if [[ $x == "M" || $y == "M" ]]; then modified=$((modified + 1)); fi
                if [[ $x == "A" || $x == "C" ]]; then staged=$((staged + 1)); fi
                if [[ $x == "R" ]]; then renamed=$((renamed + 1)); fi
                if [[ $x == "D" || $y == "D" ]]; then deleted=$((deleted + 1)); fi
            fi
            
            if [[ $x == "?" ]]; then untracked=$((untracked + 1)); fi
        done <<< "$status_out"
        
        # Ahead/behind count
        local ab_out=$(git rev-list --left-right --count HEAD...@{u} 2>/dev/null)
        if [[ -n $ab_out ]]; then
            ahead=$(echo $ab_out | awk '{print $1}')
            behind=$(echo $ab_out | awk '{print $2}')
        fi

        # Stash count
        stashed=$(git rev-list --walk-reflogs --count refs/stash 2>/dev/null || echo 0)
        
        local status_components=()
        if (( conflicted > 0 )); then status_components+=("󰞇${conflicted}"); fi
        
        if (( ahead > 0 && behind > 0 )); then status_components+=("⇕⇡${ahead}⇣${behind}")
        elif (( ahead > 0 )); then status_components+=("⇡${ahead}")
        elif (( behind > 0 )); then status_components+=("⇣${behind}"); fi
        
        if (( stashed > 0 )); then status_components+=("*${stashed}"); fi
        if (( modified > 0 )); then status_components+=("!${modified}"); fi
        if (( staged > 0 )); then status_components+=("+${staged}"); fi
        if (( renamed > 0 )); then status_components+=(">${renamed}"); fi
        if (( deleted > 0 )); then status_components+=("x${deleted}"); fi
        if (( untracked > 0 )); then status_components+=("?${untracked}"); fi
        
        if (( ${#status_components[@]} > 0 )); then
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
