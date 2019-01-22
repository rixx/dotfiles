###########
# Aliases #
###########
alias bim='vim'
alias v='vim'
alias vi="vim"

cpv() {
    rsync -pogbr -hhh --backup-dir=/tmp/rsync -e /dev/null --progress "$@"
}
compdef _files cpv
alias rsync-copy="rsync -avz --progress -h"
alias rsync-move="rsync -avz --progress -h --remove-source-files"
alias rsync-update="rsync -avzu --progress -h"
alias rsync-synchronize="rsync -avzu --delete --progress -h"

alias ll="ls -Ahl --color"
alias less=$PAGER
alias zless=$PAGER 
alias mutt="neomutt"
alias https='http --default-scheme=https'
alias ipa='ip -br -c a'

alias asdf='setxkbmap de neo -option'
alias uiae='setxkbmap de nodeadkeys -option'

alias pretalx='python -m pretalx'
alias django='python manage.py'

alias pserver="python -m http.server"

alias ap='ansible-playbook'
alias av='ansible-vault'

alias ra='ranger'

function wttr () {
    curl "https://wttr.in/$1"
}

function pyclean() {
    ZSH_PYCLEAN_PLACES=${*:-'.'}
    find ${ZSH_PYCLEAN_PLACES} -type f -name "*.py[co]" -delete
    find ${ZSH_PYCLEAN_PLACES} -type d -name "__pycache__" -delete
    find ${ZSH_PYCLEAN_PLACES} -type d -name ".mypy_cache" -delete
}

##################
# Suffix Aliases #
##################
alias -s de=firefox
alias -s com=firefox

##################
# Global Aliases #
##################
alias -g !c='| wc -l'
alias -g !l='| less'
alias -g !s='| sort'
alias -g !h='| head'
alias -g !t='| tail'
alias -g ...='../..'
alias -g ....='../../..'
alias -g .....='../../../..'
