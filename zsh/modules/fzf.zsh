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
    function cd() {
        if [[ "$#" != 0 ]]; then
            builtin cd "$@";
            return
        fi
        local cmd="${FZF_ALT_C_COMMAND:-"command find -L . -mindepth 1 \\( -path '*/\\.*' -o -fstype 'sysfs' -o -fstype 'devfs' -o -fstype 'devtmpfs' -o -fstype 'proc' \\) -prune \
            -o -type d -print 2> /dev/null | cut -b3-"}"
        local dir="$(eval "$cmd" | FZF_DEFAULT_OPTS="--height ${FZF_TMUX_HEIGHT:-40%} --reverse $FZF_DEFAULT_OPTS $FZF_ALT_C_OPTS" $(__fzfcmd) +m)"
        cd "$dir"
        unset dir # ensure this doesn't end up appearing in prompt expansion
        return $?
    }
    FZF_DEFAULT_OPTS="--inline-info --cycle --border --color=16"

    alias v='vi $(fzf)'
    alias y="yay -Slq | fzf -m --preview 'yay -Si {1}'| xargs -ro yay -S"
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
else
    alias v='vim'
fi
