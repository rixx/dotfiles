EDITOR=nvim
TERMINAL=kitty
BROWSER=firefox

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

MAKEFLAGS="-j$(nproc)" # Parallel execution for makepkg when possible
if [ -x "$(command -v nvim)" ]; then
  alias vi="$(which nvim) -O"
  if [ -x "$(command -v uv)" ]; then
    alias vim="$(which uv) run nvim -O" # Open vim in split mode if multiple files are given
  else
    alias vim="$(which nvim) -O" # Open vim in split mode if multiple files are given
  fi
else
  alias vi="$(which vim) -O"
fi
alias mosh='LANG=en_US.UTF-8 mosh'
alias feh="feh --conversion-timeout 1"  # makes feh work with svg
alias diff="diff --color -u"
alias dd="dd status=progress conv=fsync,fdatasync"
alias grep="grep --color=auto"
alias df="df -h"
alias ipython='ipython --no-banner'

alias klog="NO_COLOR=1 klog"
# always pipe klog through sed to fix terminal colours being incompatible with light themes
#function klog() {
#  klog "$@" | sed "s/38;5/31;5/g" >&2
#}

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
