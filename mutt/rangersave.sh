#!/bin/sh
kitty -e ranger --choosefile=/tmp/muttattach
cat > "`cat /tmp/muttattach`"
