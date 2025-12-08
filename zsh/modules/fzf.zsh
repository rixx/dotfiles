###################
# More fzf = good #
###################

if type fzf > /dev/null; then

    if type fd > /dev/null; then
        export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
    fi

    function fman() {
        f=$(fd . /usr/share/man/man${1:-1} -t f -x echo {/.} | fzf --prompt="man > ") && man $f
    }
    function fkill() {  # In case kill<tab> was not provided
        local pid
        if [ "$UID" != "0" ]; then
            pid=$(ps -f -u $UID | sed 1d | fzf -m | awk '{print $2}')
        else
            pid=$(ps -ef | sed 1d | fzf -m | awk '{print $2}')
        fi
        if [ "x$pid" != "x" ]
        then
            echo $pid | xargs kill -${1:-9}
        fi
    }
    FZF_DEFAULT_OPTS="--inline-info --cycle --border --color=light"

    alias yaay="yay -Slq | fzf -m --preview 'yay -Si {1}'| xargs -ro yay -S"
    alias gitlog="git log --oneline | fzf --multi --preview 'git show {+1}'"

    # Key bindings:
    # Alt-c opens a chdir
    # C-r opens history
    # **<TAB> triggers fzf
    if [[ -a /usr/share/fzf/key-bindings.zsh ]]; then
      source /usr/share/fzf/key-bindings.zsh
    fi
    if [[ -a /usr/share/fzf/completion.zsh ]]; then
      source /usr/share/fzf/completion.zsh
    fi
fi
