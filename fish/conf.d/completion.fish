######################
# Completion settings
######################

# Disable fish greeting
set -g fish_greeting

# Autosuggestion settings
set -g fish_autosuggestion_enabled 1

# Pager colors
set -g fish_pager_color_completion normal
set -g fish_pager_color_description B3A06D
set -g fish_pager_color_prefix cyan --underline
set -g fish_pager_color_progress brwhite --background=cyan

# Ctrl+Enter to accept autosuggestion
bind ctrl-enter accept-autosuggestion
