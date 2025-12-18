#!/bin/bash

swaymsg "workspace 2"
swaymsg "exec firefox"
sleep 0.5s;
swaymsg "exec kitty"
sleep 0.5s;
swaymsg "resize shrink width 20ppt"

swaymsg "workspace 11"
swaymsg "exec chromium"
swaymsg "exec chromium"
sleep 0.5s;

swaymsg "workspace 3"
swaymsg "exec steam"
swaymsg "exec pavucontrol"

