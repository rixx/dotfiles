complete -c unworktree -f -a '(git worktree list --porcelain 2>/dev/null | string replace -rf "^branch refs/heads/" "")'
complete -c unworktree -s f -l force -d 'Pass --force to git worktree remove'
complete -c unworktree -s k -l keep-issue -d 'Do not close the pxtx issue'
complete -c unworktree -s h -l help -d 'Show help'
