# General
set -g status-position bottom
set -g status-style "default"
set -g status-justify centre

# Left
set -g status-left-length 60
set -g status-left " #h |#{?client_prefix,#[reverse] #S #[noreverse], #S }"

# Right
set -g status-right " %H:%M "

# Middle
set -wg automatic-rename on
set -g window-status-format " #I#{?#{==:#W,#{pane_current_command}},,:#W} "
set -g window-status-style "default"
set -g window-status-current-format " #I#{?#{==:#W,#{pane_current_command}},,:#W} "
set -g window-status-current-style "reverse"
set -g window-status-separator ""
