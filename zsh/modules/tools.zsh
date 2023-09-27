EDITOR=nvim

PAGER=/usr/bin/less
LESSHISTFILE="$XDG_CACHE_DIR"/less/lesshist

if type ruby > /dev/null; then
  PATH="$(ruby -e 'print Gem.user_dir')/bin:$PATH"
  [ -s "/usr/bin/rbenv" ] && eval "$(rbenv init - zsh)"
fi

export PIP_REQUIRE_VIRTUALENV=true
export PYTHONDONTWRITEBYTECODE=1



############################
#  Default flags for tools #
############################

# Parallel execution for makepkg when possible
MAKEFLAGS="-j$(nproc)"

# Open vim in split mode if multiple files are given
alias vim="vim -O"

alias ls="ls --color"
alias mosh='LANG=en_US.UTF-8 mosh'
alias feh="feh --conversion-timeout 1"  # makes feh work with svg
alias diff="diff --color -u"
alias dd="dd status=progress conv=fsync,fdatasync"
alias grep="grep --color=auto"
alias df="df -h"

#############################################################
#                                                           #
#  Fix all tools not using XDG_CONFIG_HOME or XDG_DATA_HOME #
#                             :(                            #
#############################################################

alias tmux="tmux -f $XDG_CONFIG_HOME/tmux/tmux.conf"
export TMUX_TMPDIR="$XDG_RUNTIME_DIR" 

export PASSWORD_STORE_DIR="$XDG_DATA_HOME/password-store"
#export PASSWORD_STORE_KEY="7A2D8B7875486954"

export HTTPIE_CONFIG_DIR="$XDG_CONFIG_HOME/httpie"

export ANSIBLE_LOCAL_TEMP=~/.cache/ansible/tmp
export ANSIBLE_SSH_CONTROL_PATH_DIR=~/.cache/ansible/cp

alias mycli="mycli --myclirc=~/.config/myclirc --logfile=/home/rixx/.cache/mycli.log"
export MYCLI_HISTFILE=~/.local/share/mycli.hist

WORKON_HOME=$XDG_DATA_HOME/virtualenvs
[ -s "/usr/bin/virtualenvwrapper_lazy.sh" ] && source /usr/bin/virtualenvwrapper_lazy.sh
