#!/usr/bin/env zsh
# Adapted from https://github.com/robbyrussell/oh-my-zsh/blob/master/plugins/bgnotify/bgnotify.plugin.zsh

## Setup
[[ -o interactive ]] || return # don't load on non-interactive shells
[[ -z "$SSH_CLIENT" && -z "$SSH_TTY" ]] || return # don't load on a SSH connection

zmodload zsh/datetime # faster than `date`

## Zsh Hooks

function bgnotify_begin {
  bgnotify_timestamp=$EPOCHSECONDS
  bgnotify_lastcmd="${1:-$2}"
}

function bgnotify_end {
  {
    local exit_status=$?
    local elapsed=$(( EPOCHSECONDS - bgnotify_timestamp ))

    # check time elapsed
    [[ $bgnotify_timestamp -gt 0 ]] || return
    [[ $elapsed -ge $bgnotify_threshold ]] || return

    # check if executing terminal is not active
    [[ $(bgnotify_appid) != "$bgnotify_termid" ]] || return

    bgnotify_formatted "$exit_status" "$bgnotify_lastcmd" "$elapsed"
  } always {
    bgnotify_timestamp=0
  }
}

autoload -Uz add-zsh-hook
add-zsh-hook preexec bgnotify_begin
add-zsh-hook precmd bgnotify_end


## Functions

function bgnotify_formatted {
  local exit_status=$1
  local cmd="$2"

  # humanly readable elapsed time
  local elapsed="$(( $3 % 60 ))s"
  (( $3 < 60 )) || elapsed="$((( $3 % 3600) / 60 ))m $elapsed"
  (( $3 < 3600 )) || elapsed="$(( $3 / 3600 ))h $elapsed"

  if [[ $1 -eq 0 ]]; then
    bgnotify "Success (took $elapsed)" "$2"
  else
    bgnotify "Error (took $elapsed)" "$2"
  fi
}

function bgnotify_appid {
  if (( ${+commands[xprop]} )); then
    xprop -root _NET_ACTIVE_WINDOW 2>/dev/null | cut -d' ' -f5
  else
    echo $EPOCHSECONDS
  fi
}

function bgnotify {
  # $1: title, $2: message
  if (( ${+commands[notify-send]} )); then
    notify-send "$1" "$2" -i terminal -a zsh
  fi
}

## Defaults

# notify if command took longer than 10s by default
bgnotify_threshold=${bgnotify_threshold:-10}

# bgnotify_appid is slow in macOS and the terminal ID won't change, so cache it at startup
bgnotify_termid="$(bgnotify_appid)"
