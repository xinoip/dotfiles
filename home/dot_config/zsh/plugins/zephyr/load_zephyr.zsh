#!/bin/zsh

zephyr_plugins=(
    color
    completion
    compstyle
    directory
    editor
    environment
    history
    utility
)
zstyle ':zephyr:load' plugins $zephyr_plugins

source ~/.config/zsh/plugins/zephyr/zephyr.zsh
