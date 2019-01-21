# man zshoptions #

########################
# Changing directories #
########################

# Navigate to directories by naming them
setopt auto_cd 
# Push directories to push/pop list,
setopt auto_pushd
# but ignore duplicates
setopt pushd_ignore_dups
# and don't output the directory stack
setopt pushd_silent

##############
# Completion #
##############

# Automatically list menu on ambiguous choices
setopt auto_list
# Automatically add slashes to directories
setopt auto_param_slash
# … but remove them if the next character is a word delimiter
setopt auto_remove_slash
# Treat aliases as full-featured commands for completion
setopt completealiases 
# Do not beep on unsuccessful matching
unsetopt list_beep
# Pack columns to varying widths for a denser option display
setopt list_packed
# Start completing immediately, not only on second tabbing
setopt menu_complete


##########################
# Expansion and Globbing #
##########################

# Treat #, ~, and ^ as part of globbing patterns
setopt glob extendedglob


###########
# History #
###########

HISTFILE="$XDG_DATA_HOME/zsh/histfile"
HISTSIZE=10000  # This is the amount that is searched inmem
# This is the histfile length. The histfile will be trimmed once it reaches 20% beyond this value.
SAVEHIST=100000000

# Save timestamps and duration with history. The format is :<beginning time in epoch>:<elapsed time in seconds>:command
setopt extendedhistory
# Less beeping
unsetopt hist_beep
# If entering a duplicate entry to the history, remove the older one.
# Alternatives are hist_ignore_dups (do not enter duplicates in the first place) and hist_find_no_dups (enter them, but do not find them when searching)
setopt hist_ignore_all_dups
# Do not store the history command itself
setopt hist_no_store
# Use the same history for all sessions. Implies inc_append_history (that is, write to history immediately after a command has been executed, not on shell exit)
setopt sharehistory


################
# Input/Output #
################

# Don't override existing files with > redirection, or create files with >>. Use >! and >>! to override.
unsetopt clobber
# Try to correct spelling errors
setopt correct
# Hash and save command paths – slows down first execution, then speeds up the subsequent calls.
setopt hash_cmds
# Allow comments
setopt interactive_comments
# Do not show mail warnings
unsetopt mail_warning
# Print exit value when a program exits with non-0 status
setopt print_exit_value

########
# Jobs #
########

# Report the status of jobs immediately instead of waiting until before the next prompt print
setopt  notify 


#######
# ZLE #
#######

# Don't beep on errors in ZLE
setopt nobeep
# Offers typical readline shortcuts, emacs mode.
bindkey -e

# Don't use the annoying old format for colors, instead offer
# echo "$fg_bold[red]zsh $fg_no_bold[white]is $bg[blue]$fg_bold[green]nice"
autoload -U colors
colors
export LSCOLORS="Gxfxcxdxbxegedabagacad"
setopt prompt_subst

# Retrieve version control information
autoload -Uz vcs_info
zstyle ':vcs_info:*' actionformats '%F{5}(%f%s%F{5})%F{3}-%F{5}[%F{2}%b%F{3}|%F{1}%a%F{5}]%f '
zstyle ':vcs_info:*' formats '%F{5}(%f%s%F{5})%F{3}-%F{5}[%F{2}%b%F{5}]%f '
zstyle ':vcs_info:(sv[nk]|bzr):*' branchformat '%b%F{1}:%F{3}%r'
precmd () { vcs_info }

autoload -U zsh-mime-setup
zsh-mime-setup
