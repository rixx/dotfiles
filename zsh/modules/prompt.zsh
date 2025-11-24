CURRENT_BG='NONE'
SEGMENT_SEPARATOR=''
RETVAL=$?

# These colours are selected to look good with my terminal background,
# have decent contrast to the rest of the prompt, look good with white
# text, and not look too alarming (no strong reds).
# Also they spark joy.
READABLE_COLOURS=(12 18 23 24 29 30 35 36 37 38 43 54 59 67 71 72 73 74 79 90 97 103 107 108 109 125 132 133 138 140 145 168 169 203 205 209 211 241 246)
COLOUR_AMOUNT=${#READABLE_COLOURS[@]}

# we hash username@hostname, then mod it by the colour count
HOST_STRING=$(whoami)@$(hostnamectl hostname)
HOST_STRING_HASH=$(( 0x$(echo $HOST_STRING | sha1sum | cut -d ' ' -f 1 | head -c 10) ))
HOST_COLOUR_INDEX=$(( $HOST_STRING_HASH % $COLOUR_AMOUNT))
HOST_COLOUR_INDEX=$((HOST_COLOUR_INDEX+1)) # increase by one as zsh arrays start at 1

#HOST_COLOUR=24
HOST_COLOUR=${READABLE_COLOURS[$HOST_COLOUR_INDEX]}

# show sophisticated git status
# look wedisagree.zsh-theme for more possible symbols
ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$fg[cyan]%}\u272e"
ZSH_THEME_GIT_PROMPT_ADDED="%{$fg[green]%}\u271a"
ZSH_THEME_GIT_PROMPT_MODIFIED="%{$fg[blue]%}\u2738"
ZSH_THEME_GIT_PROMPT_RENAMED="%{$fg[yellow]%}\u279c"
ZSH_THEME_GIT_PROMPT_DELETED="%{$fg[red]%}\u2716"
ZSH_THEME_GIT_PROMPT_STASHED="%{$fg[blue]%}\u267b"
ZSH_THEME_GIT_PROMPT_UNMERGED="%{$fg[yellow]%}\u21cc"
ZSH_THEME_GIT_PROMPT_AHEAD="%{$fg[white]%}\u2b06"
ZSH_THEME_GIT_PROMPT_BEHIND="%{$fg[red]%}\u2b07"
ZSH_THEME_GIT_PROMPT_DIVERGED="%{$fg[yellow]%}\u2646"

ZSH_THEME_GIT_PROMPT_PREFIX=""
ZSH_THEME_GIT_PROMPT_SUFFIX=""
ZSH_THEME_GIT_PROMPT_DIRTY=" \u2718 "
ZSH_THEME_GIT_PROMPT_CLEAN=" \u2714 "
ZSH_THEME_GIT_PROMPT_CONFIG=" \u270e "

# build teststring for utf8 symbols
ZSH_THEME_GIT_PROMPT+=$ZSH_THEME_GIT_PROMPT_UNTRACKED
ZSH_THEME_GIT_PROMPT+=$ZSH_THEME_GIT_PROMPT_ADDED
ZSH_THEME_GIT_PROMPT+=$ZSH_THEME_GIT_PROMPT_MODIFIED
ZSH_THEME_GIT_PROMPT+=$ZSH_THEME_GIT_PROMPT_RENAMED
ZSH_THEME_GIT_PROMPT+=$ZSH_THEME_GIT_PROMPT_DELETED
ZSH_THEME_GIT_PROMPT+=$ZSH_THEME_GIT_PROMPT_STASHED
ZSH_THEME_GIT_PROMPT+=$ZSH_THEME_GIT_PROMPT_UNMERGED
ZSH_THEME_GIT_PROMPT+=$ZSH_THEME_GIT_PROMPT_AHEAD
ZSH_THEME_GIT_PROMPT+=$ZSH_THEME_GIT_PROMPT_BEHIND
ZSH_THEME_GIT_PROMPT+=$ZSH_THEME_GIT_PROMPT_DIVERGED

# Begin a segment
# Takes two arguments, background and foreground. Both can be omitted,
# rendering default background/foreground.
prompt_segment() {
  local bg fg
  [[ -n $1 ]] && bg="%K{$1}" || bg="%k"
  [[ -n $2 ]] && fg="%F{$2}" || fg="%f"
  if [[ $CURRENT_BG != 'NONE' && $1 != $CURRENT_BG ]]; then
    echo -n " %{$bg%F{$CURRENT_BG}%}$SEGMENT_SEPARATOR%{$fg%} "
  else
    echo -n "%{$bg%}%{$fg%} "
  fi
  CURRENT_BG=$1
  [[ -n $3 ]] && echo -n $3
}

# End the prompt, closing any open segments
prompt_end() {
  if [[ -n $CURRENT_BG ]]; then
    echo -n " %{%k%F{$CURRENT_BG}%}$SEGMENT_SEPARATOR"
  else
    echo -n "%{%k%}"
  fi
  echo -n "%{%f%}"
  CURRENT_BG=''
}

### Prompt components
# Each component will draw itself, and hide itself if no information needs to be shown

# Status:
# - was there an error
# - am I root
# - are there background jobs?
prompt_status() {
  local symbols
  symbols=()
  [[ $RETVAL -ne 0 ]] && symbols+="%{%F{red}%}✘"
  [[ $UID -eq 0 ]] && symbols+="%{%F{yellow}%}⚡"
  [[ $(jobs -l | wc -l) -gt 0 ]] && symbols+="%{%F{cyan}%}⚙"

  [[ -n "$symbols" ]] && prompt_segment blue default "$symbols"
}

# Context: user@hostname (who am I and where am I)
prompt_context() {
  prompt_segment $HOST_COLOUR white "%(!.%{%F{yellow}%}.)$HOST_STRING"
}

# Git: branch/detached head, dirty status
prompt_git_dir() {
  local CWD ref dirty INDEX STATUS=""
  CWD=`git rev-parse --show-toplevel`
  echo -n "${CWD/#$HOME/~}%u" 

  INDEX=$(command git status --porcelain --ignore-submodules=dirty --untracked-files=no 2> /dev/null)

  if [[ -n $INDEX ]]; then
    prompt_segment 215 default
    dirty="$ZSH_THEME_GIT_PROMPT_DIRTY"
    if $(echo "$INDEX" | command grep -E '^\?\? ' &> /dev/null); then
      STATUS="$ZSH_THEME_GIT_PROMPT_UNTRACKED$STATUS"
    fi
    if $(echo "$INDEX" | grep '^A  ' &> /dev/null); then
      STATUS="$ZSH_THEME_GIT_PROMPT_ADDED$STATUS"
    elif $(echo "$INDEX" | grep '^M  ' &> /dev/null); then
      STATUS="$ZSH_THEME_GIT_PROMPT_ADDED$STATUS"
    elif $(echo "$INDEX" | grep '^MM ' &> /dev/null); then
      STATUS="$ZSH_THEME_GIT_PROMPT_ADDED$STATUS"
    fi
    if $(echo "$INDEX" | grep '^ M ' &> /dev/null); then
      STATUS="$ZSH_THEME_GIT_PROMPT_MODIFIED$STATUS"
    elif $(echo "$INDEX" | grep '^AM ' &> /dev/null); then
      STATUS="$ZSH_THEME_GIT_PROMPT_MODIFIED$STATUS"
    elif $(echo "$INDEX" | grep '^MM ' &> /dev/null); then
      STATUS="$ZSH_THEME_GIT_PROMPT_MODIFIED$STATUS"
    elif $(echo "$INDEX" | grep '^ T ' &> /dev/null); then
      STATUS="$ZSH_THEME_GIT_PROMPT_MODIFIED$STATUS"
    fi
    if $(echo "$INDEX" | grep '^R  ' &> /dev/null); then
      STATUS="$ZSH_THEME_GIT_PROMPT_RENAMED$STATUS"
    fi
    if $(echo "$INDEX" | grep '^ D ' &> /dev/null); then
      STATUS="$ZSH_THEME_GIT_PROMPT_DELETED$STATUS"
    elif $(echo "$INDEX" | grep '^D  ' &> /dev/null); then
      STATUS="$ZSH_THEME_GIT_PROMPT_DELETED$STATUS"
    elif $(echo "$INDEX" | grep '^AD ' &> /dev/null); then
      STATUS="$ZSH_THEME_GIT_PROMPT_DELETED$STATUS"
    fi
    if $(echo "$INDEX" | grep '^UU ' &> /dev/null); then
      STATUS="$ZSH_THEME_GIT_PROMPT_UNMERGED$STATUS"
    fi
    if $(echo "$INDEX" | grep '^## [^ ]\+ .*ahead' &> /dev/null); then
      STATUS="$ZSH_THEME_GIT_PROMPT_AHEAD$STATUS"
    fi
    if $(echo "$INDEX" | grep '^## [^ ]\+ .*behind' &> /dev/null); then
      STATUS="$ZSH_THEME_GIT_PROMPT_BEHIND$STATUS"
    fi
    if $(echo "$INDEX" | grep '^## [^ ]\+ .*diverged' &> /dev/null); then
      STATUS="$ZSH_THEME_GIT_PROMPT_DIVERGED$STATUS"
    fi
  else
    prompt_segment 81 default
    dirty="$ZSH_THEME_GIT_PROMPT_CLEAN"
  fi

  if $(command git rev-parse --verify refs/stash >/dev/null 2>&1); then
    STATUS="$ZSH_THEME_GIT_PROMPT_STASHED$STATUS"
  fi

  ref=$(git rev-parse --abbrev-ref HEAD)
  if [[ $ref = "HEAD" ]]; then
    ref=$(git show-ref --head -s --abbrev |head -n1 2> /dev/null)
    ref="➦  $ref"
  else
    ref=" $ref"
  fi
  echo -n "$ref$dirty"
  if [[ -n $STATUS ]]; then
    echo -n " $STATUS"
  fi

  prompt_segment blue white "/`git rev-parse --show-prefix`"
}

# change into a new line and show an prompt symbol
prompt_prompt_line(){
  echo -n -e "\n"
  CURRENT_BG='NONE'
  prompt_segment blue black " "
  prompt_end
  echo -n " "
}

# build the default prompt
build_prompt() {
  RETVAL=$?
  if [[ $(git rev-parse --is-inside-work-tree 2>&1) == "true" ]]; then
    IS_GIT=1
  else
    IS_GIT=0
  fi
  echo -n -e "\n"
  prompt_status
  prompt_context
  prompt_segment blue white
  if [[ $IS_GIT -eq 1 ]]; then
    prompt_git_dir
  else
    echo -n "%~"
  fi
  prompt_end
  prompt_prompt_line
}

# build the prompt2
build_prompt2(){
  CURRENT_BG='NONE'
  if [[ `whoami` = "root" ]]; then
    prompt_segment red black ">"
  else
    prompt_segment 86 default ">"
  fi
  prompt_end
  echo -n " "
}

# build the prompt3
build_prompt3(){
  CURRENT_BG='NONE'
  if [[ `whoami` = "root" ]]; then
    prompt_segment red black "?#"
  else
    prompt_segment 86 default "?#"
  fi
  prompt_end
  echo -n " "
}

# set the actual prompt
PROMPT='%{%f%b%k%}$(build_prompt)'
PROMPT2='%{%f%b%k%}$(build_prompt2)'
PROMPT3='%{%f%b%k%}$(build_prompt3)'
PROMPT4='+ '
export PS4
