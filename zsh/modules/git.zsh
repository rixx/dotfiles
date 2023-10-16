
alias g='git'
alias ga='git add --verbose'
alias gap='git add --patch'
alias gc='git commit --verbose'
alias gc!='git commit --verbose --amend'
alias gca='git commit --verbose --all'
alias gca!='git commit --verbose --all --amend'
alias gco='git checkout'
alias gd='git diff'
alias gst='git status --short --branch'
alias git-pullall="find . -mindepth 1 -maxdepth 1 -type d -print -exec git -C {} pull \;"
alias gri='git rebase --interactive'
alias grc='git rebase --continue'
alias gra='git rebase --abort'
alias gcp='git cherry-pick'
alias gcpc='git cherry-pick --continue'
alias gps='git push'
alias gpl='git pull --rebase'
alias git-uncommit='git reset --soft HEAD~1'
alias git-hardr='git reset --hard HEAD~1'

function git-root () {
	if [[ $(git rev-parse --is-inside-work-tree 2>&1) = "true" ]]
	then
		cd $(git rev-parse --show-toplevel)
	fi
}

function gi() { curl -fL https://www.gitignore.io/api/${(j:,:)@} }

# Run git status after some git commands
# as inspired by Oleksandr Shybystyi oleksandr.shybystyi@gmail.com
gitPreAutoStatusCommands=(
    'add'
    'rm'
    'reset'
    'commit'
    'checkout'
    'mv'
    'push'
    'pull'
)

function gitStatusPrompt() {
	command git "$@"
	# Check if the command is in the list of commands to run git status after
	if [[ " ${gitPreAutoStatusCommands[@]} " =~ " $1 " ]]; then
		command git status --short --branch
	fi
}
alias git=gitStatusPrompt
