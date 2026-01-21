# Start sway if on VT 1-3
if test -z "$DISPLAY"; and test "$XDG_VTNR" -le 3; and type -q sway
    set -gx SSH_AUTH_SOCK "$XDG_RUNTIME_DIR/gcr/ssh"
    set -gx SHELL /usr/bin/fish
    exec sway
end
