#!/usr/bin/env zsh

# Interactively select and cd into a worktree.
gwcd() {
    local gwpath
    gwpath=$(git worktree list --porcelain | sed -n 's/^worktree //p' | fzf) || return
    cd "$gwpath"
}

# Create new worktree, with existing branch or new branch.
gwnew() {
    local branch="$1"
    [[ -z "$branch" ]] && {
        echo "Usage: gwnew <branch>"
        return 1
    }

    local root
    root=$(git rev-parse --show-toplevel) || return

    local gwpath="${root:h}/${branch//\//-}"

    if git show-ref --verify --quiet "refs/heads/$branch"; then
        # Existing local branch
        git worktree add "$gwpath" "$branch"
    elif git show-ref --verify --quiet "refs/remotes/origin/$branch"; then
        # Existing remote branch
        git worktree add --track -b "$branch" "$gwpath" "origin/$branch"
    else
        # New branch
        git worktree add -b "$branch" "$gwpath"
    fi && cd "$gwpath"
}

# Autocomplete for gwnew.
_gwnew() {
    local -a branches

    branches=("${(@f)$(git branch --all --format='%(refname:short)' 2>/dev/null)}")
    branches=("${(@)branches:#origin/HEAD}")

    # Strip origin/ prefix from remote branches
    branches=("${(@)branches/#origin\//}")

    _describe 'git branches' branches
}
