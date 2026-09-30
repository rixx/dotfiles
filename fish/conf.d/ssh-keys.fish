# Load the YubiKey ssh handles from disk. Not -K to prevent constant PIN popups
if status is-interactive; and test -S "$SSH_AUTH_SOCK"
    ssh-add -q ~/.ssh/id_ed25519_sk_35718943 ~/.ssh/id_ed25519_sk_37373237 2>/dev/null
end
