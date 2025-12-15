set shell := ["zsh", "-c"]

dotfiles := env_var("HOME") / ".config/dotfiles"
movesuffix := "moved-by-dotfiles-install"

[private]
default:
    @just --list

# Install all dotfiles (server + GUI)
install-all: install-server install-gui

# Install server/CLI configurations (git, vim, tmux, zsh, mutt, etc.)
install-server:
    #!/usr/bin/env zsh
    set -e
    source "{{dotfiles}}/zsh/install-lib.zsh"

    # Version control
    conflink git
    conflink jj

    # Editor
    conflink vim/colors
    conflink vim/vimrc
    link vim/coc-settings.json .config/nvim/coc-settings.json
    link vim/colors/manuscript.vim .local/share/nvim/plugged/vim-airline-themes/autoload/airline/themes/manuscript.vim
    link vim/vimrc .config/nvim/init.vim

    # Shell & terminal multiplexer
    link zsh/zshrc .zshrc
    conflink tmux/tmux.conf
    conflink lsd

    # Email
    conflink mutt/muttrc
    link mutt/notmuch-mutt .local/bin/notmuch-mutt
    link mutt/offlineimaprc .config/offlineimap/config

    # File manager (works in CLI too)
    conflink yazi

    # Ensure directories exist
    mkdir -p ~/.local/share/zsh

# Install GUI/desktop configurations (sway, waybar, rofi, kitty, etc.)
install-gui:
    #!/usr/bin/env zsh
    set -e
    source "{{dotfiles}}/zsh/install-lib.zsh"

    # Wayland/Sway
    conflink sway
    conflink hypr
    conflink waybar
    conflink kanshi
    conflink swaync
    conflink xdg-desktop-portal
    conflink xdg-desktop-portal-wlr

    # X11 (legacy)
    conflink X11

    # Terminal emulator
    conflink kitty

    # Launchers & utilities
    conflink rofi/bin
    conflink rofi/config
    conflink rofi/themes
    link rofi/rofi-pass.conf .config/rofi-pass/config
    link rofi/rofimoji.rc .config/rofimoji.rc
    conflink py3status

    # Desktop environment settings
    conflink gtk-3.0
    link kde/kdeglobals .config/kdeglobals
    conflink mimeapps.list
    link mimeapps.list .local/share/applications/mimeapps.list
    link user-dirs.dirs .config/user-dirs.dirs

    # Systemd user services (desktop-related)
    conflink systemd

    # Firefox
    if [[ -d $HOME/.mozilla ]]; then
        for profile in $HOME/.mozilla/firefox/*default*; do
            link firefox/userChrome.css $profile/chrome/userChrome.css
        done
    fi
