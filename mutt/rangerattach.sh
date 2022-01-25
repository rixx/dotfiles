#!/bin/sh
# Source: https://github.com/anufrievroman/Neomutt-File-Picker

tmpfile=.config/mutt/tmpfile
    
if \[ -z "$1" \]; then
    ranger --choosefiles $tmpfile &&    # Use Ranger
    sed -i 's/ /^V /g' $tmpfile &&
    echo "$(awk 'BEGIN {printf "%s", "push "} {printf "%s", "<attach-file>\""$0"\"<enter>"}'  $tmpfile)" > $tmpfile
elif \[ $1 == "clean" \]; then
    rm $tmpfile
fi
