#!/bin/zsh

# alias lg='lazygit'
# GPG Password flow breaks Lazygit.
alias lg='echo "foo" | gpg --sign > /dev/null; lazygit'
alias lzd='lazydocker'
alias lf='yzcd'
alias du='dust'
alias df='duf'
alias ip='ip -c'
alias ipb='ip -brief'
