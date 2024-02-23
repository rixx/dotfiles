###########
# Aliases #
###########

alias vi="vim"

# Distribute terminfo via ssh
alias kssh="kitty +kitten ssh"

if [ -x "$(command -v rsync)" ]; then
    cpv() {
	rsync -pogbr -hhh --backup-dir=/tmp/rsync -e /dev/null --progress "$@"
    }
    compdef _files cpv
    alias cpr="rsync -ah --inplace --info=progress2"
    alias rsync-copy="rsync -avz --info=progress2 -h"
    alias rsync-move="rsync -avz --info=progress2 -h --remove-source-files"
    alias rsync-update="rsync -avzu --info=progress2 -h"
    alias rsync-synchronize="rsync -avzu --delete --info=progress2 -h"
fi

certcheck() {
    echo -n | openssl s_client -connect "$@":443 2>&1 | sed -ne '/-BEGIN CERTIFICATE-/,/-END CERTIFICATE-/p' | openssl x509 -text | grep -E "DNS|Subject: CN"
}

alias ll="ls -Ahl --color"
alias mutt="neomutt"
alias https='http --default-scheme=https'
alias ipa='ip -br -c a'
alias ccat="pygmentize -g"
alias wiki="vim -c VimwikiIndex"

if [ -x "$(command -v btop)" ]; then
    alias htop="btop"
fi

alias asdf='setxkbmap de neo -option && setxkbmap -option compose:prsc'
alias uiae='setxkbmap de nodeadkeys -option && setxkbmap -option compose:prsc'

function django() {
  # Search for manage.py in current and parent directories and run given command
  if [ -f "manage.py" ]; then
      python manage.py "$@"
  elif [ "$PWD" = / ]; then
    echo "manage.py not found"
    exit 1
  else
    # subshell so we don't change the directory
    (cd .. && django "$@")
  fi
}
alias dj='django'

alias pserver="python -m http.server"
alias pydist="rm -rf dist && python -m build && twine upload dist/*"

alias ap='ansible-playbook --vault-password-file=.vault_password.sh'
alias av='ansible-vault --vault-password-file=.vault_password.sh'

alias ra='ranger'
alias dc='docker-compose'

alias work='workon $(basename $(git rev-parse --show-toplevel))'

VENV_CACHE=()
# We want to activate virtualenvs in some directories, if `workon` is available
if ! type workon >/dev/null 2>&1; then
    function cd() {
	builtin cd "$@"

	# Skip if we are in a venv, no auto-deactivation
	if [ -n "$VIRTUAL_ENV" ]; then
	    return
	fi

	# Skip if we are not in a git repo / get basename
	local gitdir="$(git rev-parse --show-toplevel 2>/dev/null)"
	if [ -z "$gitdir" ]; then
	    return
	fi

	# Check/update cache to avoid repeated directory lookups
	basename="$(basename "$gitdir")"
	if [[ " ${VENV_CACHE[@]} " =~ " ${basename} " ]]; then
	    return
	fi
	if [ ! -d "$WORKON_HOME/$basename" ]; then
	    VENV_CACHE+=("$basename")
	    return
	fi
	workon "$basename"
    }
fi

function pyclean() {
    ZSH_PYCLEAN_PLACES=${*:-'.'}
    find ${ZSH_PYCLEAN_PLACES} -type f -name "*.py[co]" -delete
    find ${ZSH_PYCLEAN_PLACES} -type d -name "__pycache__" -delete
    find ${ZSH_PYCLEAN_PLACES} -type d -name ".mypy_cache" -delete
}
alias agpy='ag --python'

alias host='systemd-resolve'

alias ...='../..'
alias ....='../../..'
alias .....='../../../..'
alias ......='../../../../..'

hash -d p=/home/rixx/src/pretalx/src
hash -d com=/home/rixx/src/pretalx/src/local/pretalx-com/pretalx_com
hash -d dotf=/home/rixx/.config/dotfiles
