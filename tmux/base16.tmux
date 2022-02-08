## set status bar
set -g status-style bg='#d0d0d0',fg=default

setw -g window-status-style bg=default,fg=default

## highlight active window
setw -g window-status-current-style bg=default,fg=default,bold,italic

## highlight activity in status bar
setw -g window-status-activity-style bg=default,fg=red,bold

## pane border and colors
set -g pane-active-border-style bg=default,fg=cyan
set -g pane-border-style bg=default,fg=blue

set -g clock-mode-colour "#8f9d6a"
set -g clock-mode-style 24

set -g message-style bg=blue,fg=white
set -g message-command-style bg="#8abeb7",fg="#000000"

set -g mode-style bg="#8f9d6a",fg="#ffffff"

#set -g status-left '#[bg=#009ddc,fg=#ffffff] ❐ #S '
set -g status-right '#(~/.config/dotfiles/tmux/status-right.sh)'
set -g status-left '#(~/.config/dotfiles/tmux/status-left.sh)'
