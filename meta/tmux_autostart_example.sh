#!/usr/bin/bash

tmux new-session -d -s mySession
tmux send-keys -t mySession "echo greetings!" C-m
tmux new-window -t mySession -c /path/to/win1 -n "win1"
tmux new-window -t mySession -c /path/to/win2 -n "win2"
tmux new-window -t mySession -c /path/to/win3 -n "win3"
tmux kill-window -t mySession:1
tmux switch-window -t mySession:1
tmux attach -t mySession
