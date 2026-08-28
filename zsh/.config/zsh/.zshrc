set -euo pipefail

. "$ZDOTDIR/configs/01_exports.sh"
. "$ZDOTDIR/configs/02_path.sh"
. "$ZDOTDIR/configs/03_ssh_agent.sh"
. "$ZDOTDIR/configs/04_aliases.sh"
. "$ZDOTDIR/configs/05_hooks.sh"
. "$ZDOTDIR/configs/06_functions.sh"
. "$ZDOTDIR/configs/07_greeters.sh"
. "$ZDOTDIR/configs/08_theme.sh"
. "$ZDOTDIR/configs/09_todo.sh"
. "$ZDOTDIR/configs/10_warpdir.sh"
. "$ZDOTDIR/configs/11_prompt.sh"

set +euo pipefail

. "$ZDOTDIR/configs/12_plugins.sh"

. "$ZDOTDIR/.env"

setup_theme
