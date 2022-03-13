###########
# Aliases #
###########
alias vim="vim -O"
alias bim='vim'
alias vi="vim"
alias im="vim"

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

alias ls="ls --color"
alias ll="ls -Ahl --color"
alias mutt="neomutt"
alias https='http --default-scheme=https'
alias ipa='ip -br -c a'
alias feh="feh --conversion-timeout 1"  # makes feh work with svg
alias colorcat="pygmentize -g"
alias diff="diff --color -u"
alias dd="dd status=progress conv=fsync,fdatasync"

if [ -x "$(command -v trickle)" ]; then
    alias yay="sudo trickle -s -d 6000 yay"
fi

if [ -x "$(command -v htop)" ]; then
    alias htop="btop"
fi

alias asdf='setxkbmap de neo -option && setxkbmap -option compose:prsc'
alias uiae='setxkbmap de nodeadkeys -option && setxkbmap -option compose:prsc'

alias pretalx='python -m pretalx'
alias django='python manage.py'
alias dj='python manage.py'

alias pserver="python -m http.server"
alias pydist="rm -rf dist && python setup.py sdist bdist_wheel && twine upload dist/*"

alias ap='ansible-playbook --vault-password-file=.vault_password.sh'
alias av='ansible-vault --vault-password-file=.vault_password.sh'

alias ra='ranger'

function wttr () {
    curl "https://wttr.in/$1"
}

alias work='workon $(basename $(git rev-parse --show-toplevel))'
alias gitstat='git rev-list --no-commit-header --format=%as --author=rixx @ | cut -d- -f1 | feedgnuplot --unset grid --histogram 0 --terminal dumb'

function pyclean() {
    ZSH_PYCLEAN_PLACES=${*:-'.'}
    find ${ZSH_PYCLEAN_PLACES} -type f -name "*.py[co]" -delete
    find ${ZSH_PYCLEAN_PLACES} -type d -name "__pycache__" -delete
    find ${ZSH_PYCLEAN_PLACES} -type d -name ".mypy_cache" -delete
}

alias ...='../..'
alias ....='../../..'
alias .....='../../../..'
alias ......='../../../../..'
