#!/bin/bash

CURRENT_BG='NONE'
SEGMENT_SEPARATOR=''

# Begin a segment
# Takes two arguments, background and foreground. Both can be omitted,
# rendering default background/foreground.
prompt_segment() {
  local bg fg
  [[ -n $1 ]] && bg="$1" || bg="%k"
  [[ -n $2 ]] && fg="$2" || fg="%f"
  if [[ $CURRENT_BG != 'NONE' && $1 != $CURRENT_BG ]]; then
    echo -n " #[fg=$bg,bg=$CURRENT_BG]$SEGMENT_SEPARATOR#[fg=$fg,bg=$bg] "
  else
    echo -n " #[default,fg=$bg]$SEGMENT_SEPARATOR#[bg=$bg,fg=$fg] "
  fi
  CURRENT_BG=$1
  [[ -n $3 ]] && echo -n " $3 "
}

# End the prompt, closing any open segments
prompt_end() {
    echo "   "
}

prompt_date() {
    when=$(date "+%Y-%m-%d")
    prompt_segment "#bcbcbc" "#000000" "$when"
}

prompt_clock() {
    time=$(date "+%H:%M")
    prompt_segment "#a8a8a8" "#000000" " $time • "
}

build_prompt() {
    RETVAL=$?
    prompt_date
    prompt_clock
    prompt_end
}

echo $(build_prompt)
