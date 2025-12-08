#!/bin/sh
kitty -e yazi --chooser-file=/tmp/muttattach
cat > "`cat /tmp/muttattach`"
