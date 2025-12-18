fpath+=( "$HOME/.cache/antidote/https-COLON--SLASH--SLASH-github.com-SLASH-mattmc3-SLASH-zephyr/plugins/color" )
source "$HOME/.cache/antidote/https-COLON--SLASH--SLASH-github.com-SLASH-mattmc3-SLASH-zephyr/plugins/color/color.plugin.zsh"
fpath+=( "$HOME/.cache/antidote/https-COLON--SLASH--SLASH-github.com-SLASH-mattmc3-SLASH-zephyr/plugins/completion" )
source "$HOME/.cache/antidote/https-COLON--SLASH--SLASH-github.com-SLASH-mattmc3-SLASH-zephyr/plugins/completion/completion.plugin.zsh"
fpath+=( "$HOME/.cache/antidote/https-COLON--SLASH--SLASH-github.com-SLASH-mattmc3-SLASH-zephyr/plugins/compstyle" )
source "$HOME/.cache/antidote/https-COLON--SLASH--SLASH-github.com-SLASH-mattmc3-SLASH-zephyr/plugins/compstyle/compstyle.plugin.zsh"
fpath+=( "$HOME/.cache/antidote/https-COLON--SLASH--SLASH-github.com-SLASH-mattmc3-SLASH-zephyr/plugins/directory" )
source "$HOME/.cache/antidote/https-COLON--SLASH--SLASH-github.com-SLASH-mattmc3-SLASH-zephyr/plugins/directory/directory.plugin.zsh"
fpath+=( "$HOME/.cache/antidote/https-COLON--SLASH--SLASH-github.com-SLASH-mattmc3-SLASH-zephyr/plugins/editor" )
source "$HOME/.cache/antidote/https-COLON--SLASH--SLASH-github.com-SLASH-mattmc3-SLASH-zephyr/plugins/editor/editor.plugin.zsh"
fpath+=( "$HOME/.cache/antidote/https-COLON--SLASH--SLASH-github.com-SLASH-mattmc3-SLASH-zephyr/plugins/environment" )
source "$HOME/.cache/antidote/https-COLON--SLASH--SLASH-github.com-SLASH-mattmc3-SLASH-zephyr/plugins/environment/environment.plugin.zsh"
fpath+=( "$HOME/.cache/antidote/https-COLON--SLASH--SLASH-github.com-SLASH-mattmc3-SLASH-zephyr/plugins/history" )
source "$HOME/.cache/antidote/https-COLON--SLASH--SLASH-github.com-SLASH-mattmc3-SLASH-zephyr/plugins/history/history.plugin.zsh"
fpath+=( "$HOME/.cache/antidote/https-COLON--SLASH--SLASH-github.com-SLASH-mattmc3-SLASH-zephyr/plugins/utility" )
source "$HOME/.cache/antidote/https-COLON--SLASH--SLASH-github.com-SLASH-mattmc3-SLASH-zephyr/plugins/utility/utility.plugin.zsh"
fpath+=( "$HOME/.cache/antidote/https-COLON--SLASH--SLASH-github.com-SLASH-Aloxaf-SLASH-fzf-tab" )
source "$HOME/.cache/antidote/https-COLON--SLASH--SLASH-github.com-SLASH-Aloxaf-SLASH-fzf-tab/fzf-tab.plugin.zsh"
if ! (( $+functions[zsh-defer] )); then
  fpath+=( "$HOME/.cache/antidote/https-COLON--SLASH--SLASH-github.com-SLASH-romkatv-SLASH-zsh-defer" )
  source "$HOME/.cache/antidote/https-COLON--SLASH--SLASH-github.com-SLASH-romkatv-SLASH-zsh-defer/zsh-defer.plugin.zsh"
fi
fpath+=( "$HOME/.cache/antidote/https-COLON--SLASH--SLASH-github.com-SLASH-zdharma-continuum-SLASH-fast-syntax-highlighting" )
zsh-defer source "$HOME/.cache/antidote/https-COLON--SLASH--SLASH-github.com-SLASH-zdharma-continuum-SLASH-fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh"
fpath+=( "$HOME/.cache/antidote/https-COLON--SLASH--SLASH-github.com-SLASH-zsh-users-SLASH-zsh-autosuggestions" )
source "$HOME/.cache/antidote/https-COLON--SLASH--SLASH-github.com-SLASH-zsh-users-SLASH-zsh-autosuggestions/zsh-autosuggestions.plugin.zsh"
fpath+=( "$HOME/.cache/antidote/https-COLON--SLASH--SLASH-github.com-SLASH-mfaerevaag-SLASH-wd" )
source "$HOME/.cache/antidote/https-COLON--SLASH--SLASH-github.com-SLASH-mfaerevaag-SLASH-wd/wd.plugin.zsh"
fpath+=( "$HOME/.cache/antidote/https-COLON--SLASH--SLASH-github.com-SLASH-romkatv-SLASH-powerlevel10k" )
source "$HOME/.cache/antidote/https-COLON--SLASH--SLASH-github.com-SLASH-romkatv-SLASH-powerlevel10k/powerlevel10k.zsh-theme"
source "$HOME/.cache/antidote/https-COLON--SLASH--SLASH-github.com-SLASH-romkatv-SLASH-powerlevel10k/powerlevel9k.zsh-theme"
