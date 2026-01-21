###########
# Aliases #
###########

# Kitty SSH
alias kssh "kitty +kitten ssh"

# Rsync
alias rsync-copy "rsync -avz --info=progress2 -h"
alias rsync-move "rsync -avz --info=progress2 -h --remove-source-files"
alias rsync-update "rsync -avzu --info=progress2 -h"
alias rsync-sync "rsync -avzu --delete --info=progress2 -h"

alias mutt neomutt
alias https "http --default-scheme=https"
alias ipa "ip -br -c a"

# btop over htop
if type -q btop
    alias htop btop
end

# Use the e script to open files even when I forget to use it
alias nvim e
alias vim e
alias vi e

# lsd over ls
if type -q lsd
    alias ls lsd
    alias ll "lsd -Alh"
else
    alias ls "ls --color"
    alias ll "ls -Ahl --color"
end

# Python/Django
alias upy "uv run python"
alias pytest "uv run pytest"
alias pserver "uv run python -m http.server"

# Other tools
alias j just
alias dc "docker compose"
alias vpn "sshuttle -r tonks 0.0.0.0/0 --dns -x 78.46.142.235"
alias host systemd-resolve
alias p8 "ping 8.8.8.8 | ts"

# Tool defaults
alias mosh "LANG=en_US.UTF-8 mosh"
alias feh "feh --conversion-timeout 1"
alias diff "diff --color -u"
alias dd "dd status=progress conv=fsync,fdatasync"
alias grep "grep --color=auto"
alias df "df -h"
alias ipython "ipython --no-banner"
alias tmux "tmux -f $XDG_CONFIG_HOME/tmux/tmux.conf"
alias twine "twine --config-file $XDG_CONFIG_HOME/pypirc"

# Directory shortcuts: ... becomes ../.. etc
function multicd
    echo cd (string repeat -n (math (string length -- $argv[1]) - 1) ../)
end
abbr --add dotdot --regex '^\.\.+$' --function multicd

# Hashed directories (zsh ~p equivalent)
# Type ~p<space> anywhere and it expands to the full path
abbr --position anywhere --add '~p' '/home/rixx/src/pretalx'
abbr --position anywhere --add '~com' '/home/rixx/src/pretalx/src/local/pretalx-com'
abbr --position anywhere --add '~dotf' "$HOME/.config/dotfiles"
abbr --position anywhere --add '~tix' '/home/rixx/src/pretix/src/local'

# Git abbreviations for frequent commands (expand as you type)
abbr -a g git
abbr -a gc 'git c'
abbr -a gd 'git d'
abbr -a gst 'git st'
