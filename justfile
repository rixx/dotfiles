set shell := ["bash", "-euo", "pipefail", "-c"]

dotfiles := env_var("HOME") / ".config/dotfiles"
movesuffix := "moved-by-dotfiles-install"

# Helper functions for install recipes (sourced via eval)
install_lib := '''
doit() {
    printf "%s\n" "$*"
    "$@"
}

link() {
    local origin="$DOTFILES/${1:?The origin must be specified.}"
    local target="${2:?The target must be specified.}"
    if [[ "${target##/home/}" == "$target" ]]; then
        target="$HOME/$target"
    fi

    if [[ -L "$target" ]]; then
        local linktarget=$(readlink -f "$target")
        if [[ "$linktarget" == "$origin" ]]; then
            :
        else
            doit mv "$target" "$target.$movesuffix"
            doit ln -s "$origin" "$target"
        fi
    elif [[ -f "$target" || -d "$target" ]]; then
        doit mv "$target" "$target.$movesuffix"
        doit ln -s "$origin" "$target"
    else
        local parent=$(dirname "$target")
        if [[ ! -d "$parent" ]]; then
            doit mkdir -p "$parent"
        fi
        doit ln -s "$origin" "$target"
    fi
}

conflink() {
    link "$1" ".config/$1"
}
'''

[private]
default:
    @just --list

# Install all dotfiles (server + GUI)
install-all: install-server install-gui

# Install vim-plug and neovim plugins
nvim-setup:
    #!/usr/bin/env bash
    set -e
    plug_path="$HOME/.local/share/nvim/site/autoload/plug.vim"
    if [[ ! -f "$plug_path" ]]; then
        echo "Installing vim-plug..."
        curl -fLo "$plug_path" --create-dirs \
            https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    else
        echo "vim-plug already installed"
    fi
    echo "Installing neovim plugins..."
    nvim --headless +PlugInstall +qall

# Install server/CLI configurations (git, vim, tmux, fish, mutt, etc.)
install-server:
    #!/usr/bin/env bash
    set -e
    DOTFILES="{{dotfiles}}"
    movesuffix="{{movesuffix}}"
    eval '{{install_lib}}'

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
    conflink fish
    conflink tmux/tmux.conf
    conflink lsd

    # Email
    conflink mutt/muttrc
    link mutt/notmuch-mutt .local/bin/notmuch-mutt
    link mutt/offlineimaprc .config/offlineimap/config

    # File manager (works in CLI too)
    conflink yazi

    # Install vim-plug and plugins
    just nvim-setup

# Install GUI/desktop configurations (sway, waybar, rofi, kitty, etc.)
install-gui:
    #!/usr/bin/env bash
    set -e
    DOTFILES="{{dotfiles}}"
    movesuffix="{{movesuffix}}"
    eval '{{install_lib}}'

    # Wayland/Sway
    conflink sway
    conflink hypr
    conflink waybar
    conflink kanshi
    conflink swaync
    conflink xdg-desktop-portal
    conflink xdg-desktop-portal-wlr

    # Tools
    conflink kitty
    conflink discord/settings.json

    # Launchers & utilities
    conflink rofi/bin
    conflink rofi/config
    conflink rofi/themes
    link rofi/rofi-pass.conf .config/rofi-pass/config
    link rofi/rofimoji.rc .config/rofimoji.rc
    link wireplumber/alsa-config.conf .config/wireplumber/wireplumber.conf.d/alsa-config.conf
    cp firefox/policies.json /etc/firefox/policies/policies.json

    # Desktop environment settings
    conflink gtk-3.0
    link kde/kdeglobals .config/kdeglobals
    conflink mimeapps.list
    link mimeapps.list .local/share/applications/mimeapps.list
    link user-dirs.dirs .config/user-dirs.dirs

    # Systemd user services (desktop-related)
    conflink systemd

    # Firefox
    if [[ -d "$HOME/.mozilla" ]]; then
        for profile in "$HOME"/.mozilla/firefox/*default*; do
            link firefox/userChrome.css "$profile/chrome/userChrome.css"
        done
    fi
