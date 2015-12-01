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
    echo " "
}

prompt_date() {
    when=$(date "+%d/%m/%Y")
    prompt_segment "#009ddc" "#111111" "$when"
}

prompt_clock() {
    time=$(date "+%H:%M")
    prompt_segment "#3c3c3c" "#ffffff" "◷ $time"
}

prompt_boxname() {
    name=$(hostname)
    prompt_segment "#009ddc" "#ffffff" "$name"
}

build_prompt() {
    RETVAL=$?
    prompt_date
    prompt_clock
    prompt_end
}

echo $(build_prompt)
