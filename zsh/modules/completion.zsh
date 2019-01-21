# Please note the completion setopts in options.zsh

# We use the new completion system, including command line options and other fanciness, not just file paths.
autoload -Uz compinit
compinit

# Colorization
zmodload zsh/complist

# Configureation goes like :completion:func:completer:cmd:arg:tag
# Use caching for slow completion
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path "$XDG_CACHE_HOME/zsh"

zstyle ':completion:*' menu select
# =, = includes the regex match, followed by the default color, and then one color for each bracket pair
zstyle ':completion:*' list-colors "=(#b) #([0-9]#)*=$color[cyan]=$color[red]"

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

# Allow SSH tab completion for mosh hostnames
compdef mosh=ssh
