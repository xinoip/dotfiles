# antigen
source $HOME/3pp/zsh/antigen.zsh
export ZSH_TMUX_AUTOSTART=true
export WD_CONFIG=$HOME/.cache/.warprc
antigen use oh-my-zsh
antigen bundle Aloxaf/fzf-tab
antigen bundle zsh-users/zsh-syntax-highlighting
antigen bundle zsh-users/zsh-autosuggestions 
antigen bundle zsh-users/zsh-completions
antigen bundle git
antigen bundle command-not-found
antigen bundle mfaerevaag/wd
antigen bundle tmux
antigen theme romkatv/powerlevel10k
antigen apply

# export
export HISTFILE=~/.cache/.zsh_history
export PATH=$HOME/.local/bin:$PATH
export PATH=$HOME/3pp/bin:$PATH
export EDITOR=nvim
NPM_PACKAGES="${HOME}/.local/npm-global"
export PATH="$PATH:$NPM_PACKAGES/bin"
export MANPATH="${MANPATH-$(manpath)}:$NPM_PACKAGES/share/man"
export WGETRC=$HOME/.config/wget/.wgetrc
export SUDO_PROMPT=$'\u001B[1m\u001B[47m\u001B[31m[sudo]\u001B[39m\u001B[49m\u001B[22m password for \u001B[1m\u001B[100m\u001B[33m%u@%h\u001B[39m\u001B[49m\u001B[22m: '
eval "$(dircolors $HOME/.config/zsh/.dircolors)"
export GOPATH=$HOME/go
export PATH=$PATH:$GOPATH/bin
fpath=(~/.antigen/bundles/mfaerevaag/wd/wd.sh $fpath)

# alias
alias piocopy="xclip -selection clipboard"
alias gpush="git push --set-upstream origin \$(git_current_branch)"
alias greset="git reset --hard @{u}"
alias gs="git status -sb"
alias gc="git commit -v"
alias gb="git branch"
alias gblog="git branch -al"
alias glog="git log --oneline --decorate --graph"
alias gcheck="git checkout"
alias gcreate="git checkout -b"
alias gpull="git pull"
alias gfetch="git fetch origin"
alias gprune="git remote prune origin"
alias bcat=bat
alias ls=lsd
alias vim=nvim
alias code="code --enable-ozone --ozone-platform=wayland"
alias foliate="com.github.johnfactotum.Foliate"
alias open="handlr open"
alias del=trash
alias rm="echo 'use del'"
alias feh="feh --conversion-timeout 1"
alias du="du -hs"
alias kimg="kitty +kitten icat"
alias clear="clear && $HOME/.config/zsh/greeter.sh"

chpwd() {
  lsd -lAh
}

lfcd () {
    # `command` is needed in case `lfcd` is aliased to `lf`
    cd "$(command lf -print-last-dir "$@")"
}
alias lf=lfcd

xsearch() {
    xbps-query -Rs "$1" | sort -u | fzf --preview-window='bottom:45%:wrap' --preview 'xbps-query -Rv {2} '
}

# $1 folder to be encrypted and uploaded
# $2 gdrive target
# $3 password
encrypt_and_upload() {
	7z a -mhe=on -p$3 $2 $1 
	gdrive files upload $2 
}

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.config/zsh/.p10k.zsh ]] || source ~/.config/zsh/.p10k.zsh

$HOME/.config/zsh/greeter.sh

