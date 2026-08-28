#!/usr/bin/env bash

autoload -U compinit
compinit

. "$ZDOTDIR/plugins/zephyr/load_zephyr.zsh"
. "$ZDOTDIR/plugins/fzf-tab/fzf-tab.plugin.zsh"
. "$ZDOTDIR/plugins/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh"
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
