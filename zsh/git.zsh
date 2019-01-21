
alias g='git'
alias ga='git add --verbose'
alias gap='git add --patch'
alias gc='git commit --verbose'
alias gc!='git commit --verbose --amend'
alias gca='git commit --verbose --all'
alias gco='git checkout'
alias gslog='git shortlog -ns'
alias gd='git diff'
alias gst='git status --short --branch'
alias git-pullall="find . -mindepth 1 -maxdepth 1 -type d -print -exec git -C {} pull \;"


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
)
function elementInArray() {
	local e
	for e in "${@:2}"; do [[ "$e" == "$1" ]] && return 0; done
	return 1
}

function gitStatusPrompt() {
	command git "$@"

	if (elementInArray $1 $gitPreAutoStatusCommands); then
		command git status --short --branch
	fi
}
alias git=gitStatusPrompt
