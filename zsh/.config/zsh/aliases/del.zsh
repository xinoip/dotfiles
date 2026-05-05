#!/bin/zsh

readonly actual_rm=$(which rm)
alias del='trash'
alias delf='${actual_rm} -f'
alias rm="echo 'use del'"
