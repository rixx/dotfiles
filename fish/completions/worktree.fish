complete -c worktree -f -a '(git for-each-ref --format="%(refname:strip=2)" --sort=-committerdate refs/heads/ 2>/dev/null)'
