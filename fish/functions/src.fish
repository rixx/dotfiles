function src
    cd (find $HOME/src -maxdepth 1 -type "d" | fzf) || exit
end
