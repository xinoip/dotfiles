unbind C-b
bind-key C-a send-prefix
set-option -g prefix C-a
bind-key C-p previous-window
bind-key C-n next-window
bind-key R source-file "~/.config/tmux/tmux.conf"
bind-key q kill-pane
bind-key v split-window -h -c '#{pane_current_path}'
bind-key h split-window -v -c '#{pane_current_path}'
bind-key c new-window -c '#{pane_current_path}'
bind-key -n M-1 select-window -t 1
bind-key -n M-2 select-window -t 2
bind-key -n M-3 select-window -t 3
bind-key -n M-4 select-window -t 4
bind-key -n M-5 select-window -t 5
bind-key -n M-6 select-window -t 6
bind-key -n M-7 select-window -t 7
bind-key -n M-8 select-window -t 8
bind-key -n M-9 select-window -t 9
bind-key b set-option status
bind-key Left swap-window -t -1 \; select-window -t -1
bind-key Right swap-window -t +1 \; select-window -t +1
bind-key C-s capture-pane -S - -E - \; save-buffer "~/last_tmux.log"\; display-message "Copied whole buffer to ~/last_tmux.log!"
