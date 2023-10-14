#!/usr/bin/env bash
# Based on powermenu.sh by Aditya Shakya / @adi1090x
# Released under GPL-3.0
# https://github.com/adi1090x/rofi/blob/master/files/powermenu/type-1/powermenu.sh

# Modified by Tobias "rixx" Kunze
# Relevant changes:
# - allow to type in action
# - use icons instead of text (necessary for string matching)
# - don't ask for confirmation before screen lock
# Irrelevant changes:
# - different hostname command
# - different list of actions / order of items

config="$HOME/.config/rofi/config/powermenu.rasi"

prompt="$(hostnamectl hostname)"
mesg="Uptime : $(uptime -p | sed -e 's/up //g')"

# Options include strings for fast selection, but only icons will be shown
option_1="shutdownpoweroff"
option_2="reboot"
option_3="logoutexit"
option_4="suspendsleephibernate"
option_5="lock"
yes='yes'
no='no'

icon_1="\0icon\x1fsystem-shutdown"
icon_2="\0icon\x1fsystem-reboot"
icon_3="\0icon\x1fgnome-logout"
icon_4="\0icon\x1fgnome-session-hibernate"
icon_5="\0icon\x1flock"
icon_yes="\0icon\x1fdialog-ok"
icon_no="\0icon\x1fdialog-cancel"

# Confirm and execute
confirm_run () {    
    selected="$(echo -e "$yes$icon_yes\n$no$icon_no" | rofi \
      -theme-str "listview {columns: 2; lines: 1;}" \
      -theme-str 'window {width: 350px;}' \
      -dmenu \
      -p 'Confirmation' \
      -mesg 'Are you sure?' \
      -markup-rows \
      -config "${config}" \
    )"
    if [[ "$selected" == "$yes" ]]; then
        ${1} && ${2} && ${3}
    else
        exit
    fi    
}

chosen="$(echo -e "$option_1$icon_1\n$option_2$icon_2\n$option_3$icon_3\n$option_4$icon_4\n$option_5$icon_5" | rofi \
    -theme-str "listview {columns: 5; lines: 1;}" \
    -theme-str 'textbox-prompt-colon {str: "";}' \
    -dmenu \
    -p "$prompt" \
    -mesg "$mesg" \
    -markup-rows \
    -config "${config}"
)"

case ${chosen} in
    "$option_1")
        confirm_run 'systemctl poweroff'
        ;;
    "$option_2")
        confirm_run 'systemctl reboot'
        ;;
    "$option_3")
        confirm_run 'systemctl i3-msg exit'
        ;;
    "$option_4")
        confirm_run 'systemctl hibernate'
        ;;
    "$option_5")
        /home/rixx/.config/dotfiles/bin/lock
        ;;
esac
