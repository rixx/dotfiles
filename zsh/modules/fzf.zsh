###################
# More fzf = good #
###################

if type fzf > /dev/null; then

    if type fd > /dev/null; then
        export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
    fi

    FZF_DEFAULT_OPTS="--inline-info --cycle --border --color=light"

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
