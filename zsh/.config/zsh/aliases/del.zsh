#!/bin/zsh

readonly actual_rm=$(which rm)
alias del='trash'
alias delf='${actual_rm} -rf'
alias rm="echo 'use del'"
