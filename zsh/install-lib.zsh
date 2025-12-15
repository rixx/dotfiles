#!/bin/zsh
# Shared functions for dotfiles installation

DOTFILES="$HOME/.config/dotfiles"
movesuffix="moved-by-dotfiles-install"

function doit {
    printf "%s\n" "$*"
    "$@"
}

function link {
    readonly origin=$DOTFILES/${1:?"The origin must be specified."}
    target=${2:?"The target must be specified."}
    if [[ "${target##/home/}" == $target ]]; then
        target=$HOME/$target
    fi

    if [[ -L $target ]]; then
        linktarget=$(readlink -f $target)
        if [[ $linktarget == $origin ]]; then
            #echo "# already linked: $origin to $target"
            :
        else
            doit mv $target $target.$movesuffix
            doit ln -s $origin $target
        fi
    elif [[ -f $target || -d $target ]]; then
        doit mv $target $target.$movesuffix
        doit ln -s $origin $target
    else
        parent=$(dirname "$target")
        if [[ ! -d $parent ]]; then
            doit mkdir -p $parent;
        fi
        doit ln -s $origin $target
    fi
}

function conflink {
    link $1 .config/$1
}
