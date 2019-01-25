CURRENT_BG='NONE'
SEGMENT_SEPARATOR=''

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

# Context: user@hostname (who am I and where am I)
prompt_context() {
  local user=`whoami`

  if [[ "$user" != "$DEFAULT_USER" || -n "$SSH_CLIENT" ]]; then
    prompt_segment black default "%(!.%{%F{yellow}%}.)$user@%m"
  fi
}

# Git: branch/detached head, dirty status
prompt_git() {
  local ref dirty
  inside_git_repo="$(git rev-parse --is-inside-work-tree 2>/dev/null)"
  if [ "$inside_git_repo" ]; then
    [[ ! (-n ZSH_THEME_GIT_PROMPT_DIRTY) ]] && ZSH_THEME_GIT_PROMPT_DIRTY='±'
    dirty=$(parse_git_dirty)
    ref=$(git symbolic-ref HEAD 2> /dev/null)
    if [[ ! $ref = *[a-zA-Z0-9]* ]]; then
      ref="$(git show-ref --head -s --abbrev |head -n1 2> /dev/null)"
      if [[ ! $ref = *[a-zA-Z0-9]* ]]; then
	ref="➦ $ref"
      fi
    fi
    if [[ $dirty == $(echo $ZSH_THEME_GIT_PROMPT_DIRTY) ]]; then
      prompt_segment yellow black
    elif [[ $dirty == $(echo $ZSH_THEME_GIT_PROMPT_CLEAN) ]]; then
      prompt_segment green black
      #prompt_segment black white
    else
      #prompt_segment magenta black
    fi
    echo -n "${ref/refs\/heads\// }$dirty$(git_prompt_status)"
    # add up/down
  fi
}

# Dir: current working directory
prompt_dir() {
  prompt_segment blue black '%~'
}

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

  [[ -n "$symbols" ]] && prompt_segment black default "$symbols"
}

# show the current path within the git repository
prompt_git_dir(){
  dirty=$(parse_git_dirty)
  if [[ $(git rev-parse --is-inside-work-tree 2>&1) == "true" ]]; then
    prompt_segment blue white "/`git rev-parse --show-prefix`"
  fi
}

# show current path, if in a git repository only the path to the .git directory
prompt_my_dir(){
  prompt_segment blue white
  if [[ $(git rev-parse --is-inside-work-tree 2>&1) == "true" ]]; then
    local CWD
    CWD=`git rev-parse --show-toplevel`
    echo -n "${CWD/#$HOME/~}%u" 
  else
    echo -n "%~"
  fi
}

# change into a new line and show an prompt symbol
prompt_prompt_line(){
  echo -n -e "\n"
  CURRENT_BG='NONE'
  if [[ `whoami` = "root" ]]; then
    prompt_segment red black "!!"
  else
    prompt_segment blue black " "
  fi
  prompt_end
  echo -n " "
}

# build the left prompt
build_prompt() {
  RETVAL=$?
  echo -n -e "\n"
	prompt_status
  prompt_context
  prompt_my_dir
  prompt_git
  prompt_git_dir
  prompt_end
  prompt_prompt_line
}

# show current time
prompt_date(){
  #prompt_segment white black "%D{%H:%M:%S %d.%m.%Y}"
  prompt_segment blue black "%*"
}

# show the return value of last command if not zero
prompt_return_code(){
  [[ $RETVAL -ne 0 ]] && prompt_segment red black "$RETVAL \u21b5"
}

# show sophisticated git status
# look wedisagree.zsh-theme for more possible symbols
ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$fg[cyan]%} \u272e"
ZSH_THEME_GIT_PROMPT_ADDED="%{$fg[green]%} \u271a"
ZSH_THEME_GIT_PROMPT_MODIFIED="%{$fg[blue]%} \u2738"
ZSH_THEME_GIT_PROMPT_RENAMED="%{$fg[yellow]%} \u279c"
ZSH_THEME_GIT_PROMPT_DELETED="%{$fg[red]%} \u2716"
ZSH_THEME_GIT_PROMPT_STASHED="%{$fg[white]%} \u267b"
ZSH_THEME_GIT_PROMPT_UNMERGED="%{$fg[yellow]%} \u21cc"
ZSH_THEME_GIT_PROMPT_AHEAD="%{$fg[green]%} \u2b06"
ZSH_THEME_GIT_PROMPT_BEHIND="%{$fg[red]%} \u2b07"
ZSH_THEME_GIT_PROMPT_DIVERGED="%{$fg[yellow]%} \u2646"

ZSH_THEME_GIT_PROMPT_PREFIX=""
ZSH_THEME_GIT_PROMPT_SUFFIX=""
ZSH_THEME_GIT_PROMPT_DIRTY=" \u2718"
ZSH_THEME_GIT_PROMPT_CLEAN=" \u2714"
ZSH_THEME_GIT_PROMPT_CONFIG=" \u270e"

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

#prompt_git_status(){
#  [[ -n "$(git_prompt_status)" ]] && prompt_segment black default "$(git_prompt_status)"
#}

# build the right prompt
#build_rprompt(){
#  RETVAL=$?
#  prompt_git_status
#  prompt_return_code
  # prompt_date
  # prompt_battery
#}

# build the prompt2
build_prompt2(){
  CURRENT_BG='NONE'
  if [[ `whoami` = "root" ]]; then
    prompt_segment red black ">"
  else
    prompt_segment green black ">"
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
    prompt_segment green black "?#"
  fi
  prompt_end
  echo -n " "
}


# set the actual prompt
PROMPT='%{%f%b%k%}$(build_prompt)'
#RPROMPT='%{%f%b%k%}$(build_rprompt)%{$reset_color%}'
PROMPT2='%{%f%b%k%}$(build_prompt2)'
PROMPT3='%{%f%b%k%}$(build_prompt3)'
PROMPT4='%{%f%b%k%}%{$fg[red]%}%N:%i>%{%f%b%k%} '
export PS4
