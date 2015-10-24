# Not oh-my-zsh
#############
# Variables #
#############
HISTFILE=~/.histfile
HISTSIZE=10000

EDITOR=vim
JAVA_HOME=/usr/lib/jvm/java-7-openjdk/
PATH=$PATH:/usr/local/bin:/usr/bin:/bin:/usr/local/sbin:/usr/sbin:/sbin:/usr/local/games:~/.bin:/home/share/.bin
DOCKER_DIRS="~/Projects/aexea/ax/dev/axmeta,~/Projects/aexea/myax,~/Projects/aexea/morgana"
PAGER=/usr/bin/vimpager

WORKON_HOME=~/.virtualenvs
source /usr/bin/virtualenvwrapper.sh

###############
# zsh options #
###############
setopt incappendhistory
setopt sharehistory
setopt extendedhistory

#setops: 
setopt auto_cd 
setopt extendedglob notify completealiases 
setopt interactivecomments
autoload -Uz compinit
autoload -U colors
compinit
colors

zstyle ':completion:*' menu select
zstyle ':completion:*:killall:*' command 'ps -u $USER -o cmd'

#Display CPU stats for commands taking more than 10 seconds
REPORTTIME=10

###########################
# oh-my-zsh configuration #
###########################
ZSH=$HOME/.oh-my-zsh
ZSH_CUSTOM=$HOME/.oh-my-zsh/custom
ZSH_THEME="ttb"

plugins=(battery bgnotify colored-man command-not-found cp dirhistory docker docker-compose extract git history history-substring-search pass python rsync ssh-agent sudo systemctl)
## plugins
# bgnotify: notification when long-running commands end
# command-not-found: requires pkgfile
# cp: cpv uses rsync instead of cp
# dirhistory: Alt-left and Alt-right navigate the last directories
# extract: x file extracts most known archive types
# sudo: <ESC><ESC> toggles sudo
# systemctl: alias all systemctl commands to sc-<command>, inserting sudo where needed
##

source $ZSH/oh-my-zsh.sh

###########
# Aliases #
###########
alias vi="vim"
alias dc="docker-compose"
alias packer="packer --preview"
alias ll="ls -Ahl --color"

alias fucking="sudo"
alias fuck='sudo $(fc -ln -1)'
alias please="sudo"

alias pycharm="/opt/pycharm/bin/pycharm.sh"
alias intellij="idea.sh"
alias stick="wine ~/.wine/drive_c/Program\ Files\ \(x86\)/Brother/PE-DESIGN\ NEXT/Embedit.exe"
alias pserver="python -m http.server"

alias less=$PAGER
alias zless=$PAGER 
