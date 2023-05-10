# Please note the completion setopts in options.zsh

# We use the new completion system, including command line options and other fanciness, not just file paths.
# We only want to update the compinit cache once a day
# The globbing is a little complicated here, via https://gist.github.com/ctechols/ca1035271ad134841284:
# - '#q' is an explicit glob qualifier that makes globbing work within zsh's [[ ]] construct.
# - 'N' makes the glob pattern evaluate to nothing when it doesn't match (rather than throw a globbing error)
# - '.' matches "regular files"
# - 'mh+24' matches files (or directories or whatever) that are older than 24 hours.
autoload -Uz compinit
if [[ -n ~/.cache/compinit(#qN.mh+24) ]]; then
    compinit -d ~/.cache/compinit
else
    compinit -d ~/.cache/compinit -C
fi

# Colorization
zmodload zsh/complist

# Configureation goes like :completion:func:completer:cmd:arg:tag
# Use caching for slow completion
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path "$XDG_CACHE_HOME/zsh"

zstyle ':completion:*' menu select
# =, = includes the regex match, followed by the default color, and then one color for each bracket pair
zstyle ':completion:*' list-colors "=(#b) #([0-9]#)*=$color[cyan]=$color[red]"

# support sudo completion
zstyle ':completion::complete:*' gain-privileges 1

# Fuzzy matching of completions when mistyping
zstyle ':completion:*' completer _complete _match _approximate
zstyle ':completion:*:match:*' original only
zstyle ':completion:*:approximate:*' max-errors 1 numeric

# Don't provide completion for commands I don't have
zstyle ':completion:*:functions' ignored-patterns '_*'

# Complete kill IDs with menu selection
zstyle ':completion:*:killall:*' command 'ps -u $USER -o cmd'
zstyle ':completion:*:*:kill:*' menu yes select
zstyle ':completion:*:kill:*'   force-list always

# Remove trailing slashes in directories from completion
zstyle ':completion:*' squeeze-slashes true

# Prevent cd from selecting the parent directory in ../…
zstyle ':completion:*:cd:*' ignore-parents parent pwd

# Make zsh know about hosts already accessed by SSH
zstyle -e ':completion:*:(ssh|scp|sftp|rsh|rsync):hosts' hosts 'reply=(${=${${(f)"$(cat {/etc/ssh_,~/.ssh/known_}hosts(|2)(N) /dev/null)"}%%[# ]*}//,/ })'

# Allow SSH tab completion for mosh hostnames
compdef mosh=ssh
compdef rsync-copy=rsync
compdef rsync-move=rsync
