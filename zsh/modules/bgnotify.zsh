#!/usr/bin/env zsh
# Adapted from https://github.com/robbyrussell/oh-my-zsh/blob/master/plugins/bgnotify/bgnotify.plugin.zsh

[[ -o interactive ]] || return #interactive only!
zmodload zsh/datetime || { print "can't load zsh/datetime"; return } # faster than date()
autoload -Uz add-zsh-hook || { print "can't add zsh hook!"; return }

(( ${+bgnotify_threshold} )) || bgnotify_threshold=20 #default 10 seconds


function bgnotify_formatted { ## args: (exit_status, command, elapsed_seconds)
	elapsed="$(( $3 % 60 ))s"
	(( $3 >= 60 )) && elapsed="$((( $3 % 3600) / 60 ))m $elapsed"
	(( $3 >= 3600 )) && elapsed="$(( $3 / 3600 ))h $elapsed"
	[ $1 -eq 0 ] && notify-send "#win (took $elapsed)" "$2" || notify-send "#fail (took $elapsed)" "$2"
}

currentWindowId () {
	xprop -root 2> /dev/null | awk '/NET_ACTIVE_WINDOW/{print $5;exit} END{exit !$5}' || echo "0"
}


## Zsh hooks ##

bgnotify_begin() {
  bgnotify_timestamp=$EPOCHSECONDS
  bgnotify_lastcmd="$1"
  bgnotify_windowid=$(currentWindowId)
}

bgnotify_end() {
  didexit=$?
  elapsed=$(( EPOCHSECONDS - bgnotify_timestamp ))
  past_threshold=$(( elapsed >= bgnotify_threshold ))
  if (( bgnotify_timestamp > 0 )) && (( past_threshold )); then
    if [ $(currentWindowId) != "$bgnotify_windowid" ]; then
      print -n "\a"
      bgnotify_formatted "$didexit" "$bgnotify_lastcmd" "$elapsed"
    fi
  fi
  bgnotify_timestamp=0 #reset it to 0!
}

## only enable if a local (non-ssh) connection
if [ -z "$SSH_CLIENT" ] && [ -z "$SSH_TTY" ]; then
  add-zsh-hook preexec bgnotify_begin
  add-zsh-hook precmd bgnotify_end
fi
