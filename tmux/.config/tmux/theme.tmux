# Configure Catppuccin
set -g @catppuccin_flavor "macchiato"
set -g @catppuccin_status_background "none"
set -g @catppuccin_window_status_style "none"
set -g @catppuccin_pane_status_enabled "off"
set -g @catppuccin_pane_border_status "off"

set -g @thm_bg "#000000"

# Configure Online
set -g @online_icon "ok"
set -g @offline_icon "nok"

# status left look and feel
set -g status-left-length 100
set -g status-left ""
set -ga status-left "#{?client_prefix,#{#[bg=#{@thm_red},fg=#{@thm_bg},bold]  #S },#{#[bg=#{@thm_bg},fg=#{@thm_green}]  #S }}"
set -ga status-left "#[bg=#{@thm_bg},fg=#{@thm_overlay_0},none]│"
set -ga status-left "#[bg=#{@thm_bg},fg=#{@thm_maroon}]  #{pane_current_command} "
set -ga status-left "#[bg=#{@thm_bg},fg=#{@thm_overlay_0},none]│"
set -ga status-left "#[bg=#{@thm_bg},fg=#{@thm_blue}]  #{=/-32/...:#{s|$USER|~|:#{b:pane_current_path}}} "
set -ga status-left "#[bg=#{@thm_bg},fg=#{@thm_overlay_0},none]#{?window_zoomed_flag,│,}"
set -ga status-left "#[bg=#{@thm_bg},fg=#{@thm_yellow}]#{?window_zoomed_flag,  zoom ,}"

# status right look and feel
set -g status-right-length 100
set -g status-right ""
# set -ga status-right "#{?#{e|>=:10,#{battery_percentage}},#{#[bg=#{@thm_red},fg=#{@thm_bg}]},#{#[bg=#{@thm_bg},fg=#{@thm_pink}]}} #{battery_icon} #{battery_percentage} "
# set -ga status-right "#[bg=#{@thm_bg},fg=#{@thm_overlay_0}, none]│"
set -ga status-right "#[bg=#{@thm_bg},fg=#689d6a]  #{cpu_percentage} "
set -ga status-right "#[bg=#{@thm_bg},fg=#{@thm_overlay_0}, none]│"
set -ga status-right "#[bg=#{@thm_bg}]#{?#{==:#{online_status},ok},#[fg=#{@thm_mauve}] 󰖩 on ,#[fg=#{@thm_red},bold]#[reverse] 󰖪 off }"
set -ga status-right "#[bg=#{@thm_bg},fg=#{@thm_overlay_0}, none]│"
set -ga status-right "#[bg=#{@thm_bg},fg=#{@thm_blue}] 󰭦 %Y-%m-%d 󰅐 %H:%M "


# Configure Tmux
set -g status-position top
set -g status-style "bg=#{@thm_bg}"
set -g status-justify "absolute-centre"

# pane border look and feel
# setw -g pane-border-status top
# setw -g pane-border-format ""
# setw -g pane-active-border-style "bg=#{@thm_bg},fg=#{@thm_overlay_0}"
# setw -g pane-border-style "bg=#{@thm_bg},fg=#{@thm_surface_0}"
# setw -g pane-border-lines single

# window look and feel
set -wg automatic-rename on
set -g automatic-rename-format "Window"

set -g window-status-format " #I#{?#{!=:#{window_name},Window},: #W,} "
set -g window-status-style "bg=#{@thm_bg},fg=#{@thm_rosewater}"
set -g window-status-last-style "bg=#{@thm_bg},fg=#{@thm_peach}"
set -g window-status-activity-style "bg=#{@thm_red},fg=#{@thm_bg}"
set -g window-status-bell-style "bg=#{@thm_red},fg=#{@thm_bg},bold"
set -gF window-status-separator "#[bg=#{@thm_bg},fg=#{@thm_overlay_0}]│"

set -g window-status-current-format " #I#{?#{!=:#{window_name},Window},: #W,} "
set -g window-status-current-style "bg=#{@thm_peach},fg=#{@thm_bg},bold"
