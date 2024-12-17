#!/usr/bin/env bash

# Used for generating minimal.tmux to use without TPM
# https://github.com/niksingh710/minimal-tmux-status

get_tmux_option() {
  # This helper function will get the value of the tmux variable
  # or set it to a given value if it is not set
  option=$1
  default_value="$2"

  option_value=$(tmux show-options -gqv "$option")

  if [ "$option_value" != "" ]; then
    echo "$option_value"
    return
  fi

  echo "$default_value"
}

# Most of the variables are prefixed with `@minimal-tmux-` so that tmux has a unique namespace
#
# The variables are:
# - @minimal-tmux-bg: background color of the status line

# - @minimal-tmux-fg: foreground color of the status line
# - @minimal-tmux-status: position of the status line (top or bottom)
# - @minimal-tmux-justify: justification of the status line (left, centre or right)
# - @minimal-tmux-indicator: whether to show the indicator of the prefix
# - @minimal-tmux-indicator-str: string of the indicator
# - @minimal-tmux-right: whether to show the right side of the status line
# - @minimal-tmux-left: whether to show the left side of the status line
# - @minimal-tmux-status-right: content of the right side of the status line
# - @minimal-tmux-status-left: content of the left side of the status line
# - @minimal-tmux-status-right-extra: extra content of the right side of the status line
# - @minimal-tmux-status-left-extra: extra content of the left side of the status line
# - @minimal-tmux-window-status-format: format of the window status
# - @minimal-tmux-expanded-icon: icon for expanded windows
# - @minimal-tmux-show-expanded-icon-for-all-tabs: whether to show the expanded icon for all tabs
# - @minimal-tmux-use-arrow: whether to use arrows in the status line

# - @minimal-tmux-right-arrow: right arrow symbol
# - @minimal-tmux-left-arrow: right left symbol

default_color="#[bg=default,fg=default,bold]"

# variables
bg=$(get_tmux_option "@minimal-tmux-bg" '#d8a657')
fg=$(get_tmux_option "@minimal-tmux-fg" '#000000')

use_arrow=$(get_tmux_option "@minimal-tmux-use-arrow" false)
larrow="$("$use_arrow" && get_tmux_option "@minimal-tmux-left-arrow" "")"
rarrow="$("$use_arrow" && get_tmux_option "@minimal-tmux-right-arrow" "")"

status=$(get_tmux_option "@minimal-tmux-status" "bottom")
justify=$(get_tmux_option "@minimal-tmux-justify" "centre")

indicator_state=$(get_tmux_option "@minimal-tmux-indicator" false)
indicator_str=$(get_tmux_option "@minimal-tmux-indicator-str" " tmux ")
indicator=$("$indicator_state" && echo " $indicator_str ")

right_state=$(get_tmux_option "@minimal-tmux-right" false)
left_state=$(get_tmux_option "@minimal-tmux-left" false)

status_right=$("$right_state" && get_tmux_option "@minimal-tmux-status-right" "#S")
status_left=$("$left_state" && get_tmux_option "@minimal-tmux-status-left" "${default_color}#{?client_prefix,,${indicator}}#[bg=${bg},fg=${fg},bold]#{?client_prefix,${indicator},}${default_color}")
status_right_extra="$status_right$(get_tmux_option "@minimal-tmux-status-right-extra" "")"
status_left_extra="$status_left$(get_tmux_option "@minimal-tmux-status-left-extra" "")"

window_status_format=$(get_tmux_option "@minimal-tmux-window-status-format" ' #I:#W ')

expanded_icon=$(get_tmux_option "@minimal-tmux-expanded-icon" '󰊓 ')
show_expanded_icon_for_all_tabs=$(get_tmux_option "@minimal-tmux-show-expanded-icon-for-all-tabs" false)

# Output file
output_file="minimal.tmux"

# Clear the content of the output file if it already exists
>"$output_file"

# Generate the tmux commands and write to the output file
echo " set-option -g status-position \"$status\"" >>"$output_file"
echo " set-option -g status-style bg=default,fg=default" >>"$output_file"
echo " set-option -g status-justify \"$justify\"" >>"$output_file"

echo " set-option -g status-left \"$status_left_extra\"" >>"$output_file"
echo " set-option -g status-right \"$status_right_extra\"" >>"$output_file"

echo " set-option -g window-status-format \"$window_status_format\"" >>"$output_file"

if [ "$show_expanded_icon_for_all_tabs" = true ]; then
  echo " set-option -g window-status-format \" ${window_status_format}#{?window_zoomed_flag,${expanded_icon},}\"" >>"$output_file"
fi

echo " set-option -g window-status-current-format \"#[fg=${bg}]$larrow#[bg=${bg},fg=${fg}]${window_status_format}#{?window_zoomed_flag,${expanded_icon},}#[fg=${bg},bg=default]$rarrow\"" >>"$output_file"

# Make the output file executable
chmod +x "$output_file"

# Print a message
echo "The tmux configuration commands have been written to $output_file"
