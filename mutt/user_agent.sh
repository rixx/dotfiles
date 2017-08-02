#!/bin/bash
array[0]="Guess what."
array[1]="Not telling."
array[2]="Using a butterfly, xkcd style"
array[3]="Buttold MS Outlook on Windows 95"
array[4]="Really, really, really hip webmailer"
array[5]="I never sent this, you are imagining it"
array[6]="Never gonna give you up"
array[7]="Wer das liest, ist doof"

size=${#array[@]}
index=$(($RANDOM % $size))
echo my_hdr User-Agent: ${array[$index]}
