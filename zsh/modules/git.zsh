# Shell aliases for frequent commands
alias g='git'
alias gc='git c'
alias gd='git d'
alias gst='git st'

# Functions that need shell features
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
