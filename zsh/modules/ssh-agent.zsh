# via https://github.com/robbyrussell/oh-my-zsh/blob/master/plugins/ssh-agent/ssh-agent.plugin.zsh
typeset _agent_forwarding _ssh_env_cache

function _start_agent() {
	echo starting ssh-agent...
	ssh-agent -s | sed 's/^echo/#echo/' >! $_ssh_env_cache
	chmod 600 $_ssh_env_cache
	. $_ssh_env_cache > /dev/null
}

function _add_identities() {
	local id line sig
	local -a identities loaded not_loaded signatures
	zstyle -a :omz:plugins:ssh-agent identities identities

	# check for .ssh folder presence
	if [[ ! -d $HOME/.ssh ]]; then
		return
	fi

	# add default keys if no identities were set up via zstyle
	# this is to mimic the call to ssh-add with no identities
	# key list found on `ssh-add` man page's DESCRIPTION section
	for id in id_rsa id_dsa id_ecdsa id_ed25519 identity; do
		# check if file exists
		[[ -f "$HOME/.ssh/$id" ]] && identities+=$id
	done

	# get list of loaded identities' signatures
	for line in ${(f)"$(ssh-add -l)"}; do loaded+=${${(z)line}[2]}; done

	# get signatures of private keys
	for id in $identities; do
		signatures+="$(ssh-keygen -lf "$HOME/.ssh/$id" | awk '{print $2}')	$id"
	done

	# add identities if not already loaded
	for sig in $signatures; do
		id="$(cut -f2 <<< $sig)"
		sig="$(cut -f1 <<< $sig)"
		[[ ${loaded[(I)$sig]} -le 0 ]] && not_loaded+="$HOME/.ssh/$id"
	done

	[[ -n "$not_loaded" ]] && ssh-add ${^not_loaded}
}

# Get the filename to store/lookup the environment from
_ssh_env_cache="$HOME/.ssh/environment-$SHORT_HOST"

if [[ $DISPLAY ]]; then
	# test if agent-forwarding is running
	if [[ -n "$SSH_AUTH_SOCK" ]]; then
		# Add a nifty symlink for screen/tmux if agent forwarding
		[[ -L $SSH_AUTH_SOCK ]] || ln -sf "$SSH_AUTH_SOCK" /tmp/ssh-agent-$USER-screen
	elif [[ -f "$_ssh_env_cache" ]]; then
		# Source SSH settings, if applicable
		. $_ssh_env_cache > /dev/null
		if [[ $USER == "root" ]]; then
			FILTER="ax"
		else
			FILTER="x"
		fi
		ps $FILTER | grep ssh-agent | grep -q $SSH_AGENT_PID || {
			_start_agent
			_add_identities
		}
	else
		_start_agent
		_add_identities
	fi
fi

# tidy up after ourselves
unset _agent_forwarding _ssh_env_cache
unfunction _start_agent _add_identities
