fpath+=( "$HOME/.cache/antidote/github.com/mattmc3/zephyr/plugins/color" )
source "$HOME/.cache/antidote/github.com/mattmc3/zephyr/plugins/color/color.plugin.zsh"
fpath+=( "$HOME/.cache/antidote/github.com/mattmc3/zephyr/plugins/completion" )
source "$HOME/.cache/antidote/github.com/mattmc3/zephyr/plugins/completion/completion.plugin.zsh"
fpath+=( "$HOME/.cache/antidote/github.com/mattmc3/zephyr/plugins/compstyle" )
source "$HOME/.cache/antidote/github.com/mattmc3/zephyr/plugins/compstyle/compstyle.plugin.zsh"
fpath+=( "$HOME/.cache/antidote/github.com/mattmc3/zephyr/plugins/directory" )
source "$HOME/.cache/antidote/github.com/mattmc3/zephyr/plugins/directory/directory.plugin.zsh"
fpath+=( "$HOME/.cache/antidote/github.com/mattmc3/zephyr/plugins/editor" )
source "$HOME/.cache/antidote/github.com/mattmc3/zephyr/plugins/editor/editor.plugin.zsh"
fpath+=( "$HOME/.cache/antidote/github.com/mattmc3/zephyr/plugins/environment" )
source "$HOME/.cache/antidote/github.com/mattmc3/zephyr/plugins/environment/environment.plugin.zsh"
fpath+=( "$HOME/.cache/antidote/github.com/mattmc3/zephyr/plugins/history" )
source "$HOME/.cache/antidote/github.com/mattmc3/zephyr/plugins/history/history.plugin.zsh"
fpath+=( "$HOME/.cache/antidote/github.com/mattmc3/zephyr/plugins/utility" )
source "$HOME/.cache/antidote/github.com/mattmc3/zephyr/plugins/utility/utility.plugin.zsh"
fpath+=( "$HOME/.cache/antidote/github.com/Aloxaf/fzf-tab" )
source "$HOME/.cache/antidote/github.com/Aloxaf/fzf-tab/fzf-tab.plugin.zsh"
if ! (( $+functions[zsh-defer] )); then
  fpath+=( "$HOME/.cache/antidote/github.com/romkatv/zsh-defer" )
  source "$HOME/.cache/antidote/github.com/romkatv/zsh-defer/zsh-defer.plugin.zsh"
fi
fpath+=( "$HOME/.cache/antidote/github.com/zdharma-continuum/fast-syntax-highlighting" )
zsh-defer source "$HOME/.cache/antidote/github.com/zdharma-continuum/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh"
fpath+=( "$HOME/.cache/antidote/github.com/zsh-users/zsh-autosuggestions" )
source "$HOME/.cache/antidote/github.com/zsh-users/zsh-autosuggestions/zsh-autosuggestions.plugin.zsh"
fpath+=( "$HOME/.cache/antidote/github.com/mfaerevaag/wd" )
source "$HOME/.cache/antidote/github.com/mfaerevaag/wd/wd.plugin.zsh"
