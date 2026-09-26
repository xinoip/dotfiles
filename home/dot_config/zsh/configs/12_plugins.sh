#!/usr/bin/env bash

zstyle ':zephyr:plugin:completion' immediate yes
zstyle ':zephyr:plugin:completion' use-cache yes
zstyle :omz:plugins:ssh-agent agent-forwarding yes
zstyle :omz:plugins:ssh-agent honor-existing yes
zstyle :omz:plugins:ssh-agent lazy yes
zstyle :omz:plugins:ssh-agent lifetime 4h
zstyle :omz:plugins:ssh-agent quiet yes
ZSH_AUTOSUGGEST_MANUAL_REBIND=1

. "$ZDOTDIR/plugins/zephyr/load_zephyr.zsh"
. "$ZDOTDIR/plugins/fzf-tab/fzf-tab.plugin.zsh"
. "$ZDOTDIR/plugins/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh"
. "$ZDOTDIR/plugins/zsh-autosuggestions/zsh-autosuggestions.plugin.zsh"
. "$ZDOTDIR/plugins/omz-ssh-agent/ssh-agent.plugin.zsh"

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
