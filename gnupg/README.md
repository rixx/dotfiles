Public halves of the YubiKey GPG keys (35718943, 37373237). A fresh machine needs them before the card is usable, e.g. to decrypt pass:

```
gpg --import ~/.config/dotfiles/gnupg/yubikey-*.asc
gpg --card-status
```
