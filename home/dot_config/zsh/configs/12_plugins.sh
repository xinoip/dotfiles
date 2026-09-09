#!/usr/bin/env bash

# Initialize once through Zephyr, before fzf-tab wraps completion widgets.
# Refresh the completion cache every 20 hours; run_compinit -f forces a refresh.
zstyle ':zephyr:plugin:completion' immediate yes
zstyle ':zephyr:plugin:completion' use-cache yes

. "$ZDOTDIR/plugins/zephyr/load_zephyr.zsh"
. "$ZDOTDIR/plugins/fzf-tab/fzf-tab.plugin.zsh"
. "$ZDOTDIR/plugins/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh"
# All widgets are installed before the first prompt, so bind suggestions once.
# After adding widgets interactively, run _zsh_autosuggest_start to rebind them.
ZSH_AUTOSUGGEST_MANUAL_REBIND=1
. "$ZDOTDIR/plugins/zsh-autosuggestions/zsh-autosuggestions.plugin.zsh"

# Override history settings of Zephyr
setopt share_history
HISTSIZE=100000
SAVEHIST=100000

# Easy edit current line in $EDITOR
autoload -Uz edit-command-line
zle -N edit-command-line
bindkey '^X^E' edit-command-line

# Remove clear screen binding, it's useless.
bindkey -r '^l'
