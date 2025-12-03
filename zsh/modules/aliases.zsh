###########
# Aliases #
###########

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

alias mutt="neomutt"
alias https='http --default-scheme=https'
alias ipa='ip -br -c a'
alias ccat="pygmentize -g"
alias wiki="vim -c VimwikiIndex"

if [ -x "$(command -v btop)" ]; then
    alias htop="btop"
fi
if [ -x "$(command -v lsd)" ]; then
    alias ls="lsd"
    alias ll="lsd -Alh"
else
    alias ls="ls --color"
    alias ll="ls -Ahl --color"
fi

alias asdf='setxkbmap de neo -option && setxkbmap -option compose:prsc'
alias uiae='setxkbmap de nodeadkeys -option && setxkbmap -option compose:prsc'

alias py='uv run python'
alias pytest='uv run pytest'
function django() {
  # Search for manage.py in current and parent directories and run given command
  if [ -f "manage.py" ]; then
      uv run python manage.py "$@"
  elif [ "$PWD" = / ]; then
    echo "manage.py not found"
    exit 1
  else
    # subshell so we don't change the directory
    (cd .. && django "$@")
  fi
}
alias j='just'
alias dj='django'
alias pserver="uv run python -m http.server"
alias ap='ansible-playbook --vault-password-file=.vault_password.sh'
alias av='ansible-vault --vault-password-file=.vault_password.sh'

function pyclean() {
    ZSH_PYCLEAN_PLACES=${*:-'.'}
    find ${ZSH_PYCLEAN_PLACES} -type f -name "*.py[co]" -delete
    find ${ZSH_PYCLEAN_PLACES} -type d -name "__pycache__" -delete
    find ${ZSH_PYCLEAN_PLACES} -type d -name ".mypy_cache" -delete
}

alias host='systemd-resolve'
alias dc='docker-compose'

# Alias the most common sshuttle command
alias vpn='sshuttle -r tonks 0.0.0.0/0 --dns -x 78.46.142.235'

alias ...='../..'
alias ....='../../..'
alias .....='../../../..'
alias ......='../../../../..'

hash -d p=/home/rixx/src/pretalx/src
hash -d com=/home/rixx/src/pretalx/src/local/pretalx-com/pretalx_com
hash -d dotf=/home/rixx/.config/dotfiles
hash -d tix=/home/rixx/src/pretix/src/local
