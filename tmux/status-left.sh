#!/bin/bash

CURRENT_BG='NONE'
SEGMENT_SEPARATOR=''

# Begin a segment
# Takes two arguments, background and foreground. Both can be omitted,
# rendering default background/foreground.
prompt_segment() {
  local bg fg
  [[ -n $1 ]] && bg="$1" || bg="%k"
  [[ -n $2 ]] && fg="$2" || fg="%f"
  if [[ $CURRENT_BG != 'NONE' && $1 != $CURRENT_BG ]]; then
    echo -n " #[bg=$bg,fg=$CURRENT_BG]$SEGMENT_SEPARATOR#[fg=$fg] "
  else
    echo -n "#[bg=$bg,fg=$fg] "
  fi
  CURRENT_BG=$1
  [[ -n $3 ]] && echo -n $3
}

# End the prompt, closing any open segments
prompt_end() {
  if [[ -n $CURRENT_BG ]]; then
    echo -n " #[bg=default,fg=$CURRENT_BG]$SEGMENT_SEPARATOR"
  else
    echo -n ""
  fi
  echo -n ""
  CURRENT_BG=''
}

prompt_context() {
  prompt_segment "#dd9975" "#ffffff" "❐ #yo"
}

prompt_boxname() {
    name=$(hostname)
    prompt_segment "#3c3c3c" "#ffffff" "$name"
}

build_prompt() {
    RETVAL=$?
    #prompt_context
    prompt_boxname
    prompt_end
}

echo $(build_prompt)
