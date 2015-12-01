## set status bar
set -g status-bg '#3c3c3c'
set -g status-fg "#c3c3c3"

## highlight active window
#setw -g window-status-current-bg '#3c3c3c'
#setw -g window-status-current-bg '#dd9975'
#setw -g window-status-current-fg '#ffffff'
setw -g window-status-current-bg '#ffffff'
setw -g window-status-current-fg '#3c3c3c'

## highlight activity in status bar
setw -g window-status-activity-fg '#151515'
setw -g window-status-activity-bg '#ee2e24'

## pane border and colors
set -g pane-active-border-bg default
set -g pane-active-border-fg '#151515'
set -g pane-border-bg default
set -g pane-border-fg '#151515'

set -g clock-mode-colour "#8f9d6a"
set -g clock-mode-style 24

set -g message-bg "#ffd204"
set -g message-fg "#151515"

set -g message-command-bg "#8abeb7"
set -g message-command-fg "#000000"

set -g mode-bg "#8f9d6a"
set -g mode-fg "#ffffff"

#set -g status-left '#[bg=#009ddc,fg=#ffffff] ❐ #S '
set -g status-right '#(~/.config/dotfiles/tmux/status-right.sh)'
set -g status-left '#(~/.config/dotfiles/tmux/status-left.sh)'
