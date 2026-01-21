#############
# Variables #
#############

set -gx XDG_CONFIG_HOME "$HOME/.config"
set -gx XDG_CACHE_HOME "$HOME/.cache"
set -gx XDG_DATA_HOME "$HOME/.local/share"
set -gx XDG_STATE_HOME "$HOME/state/"

fish_add_path -p $HOME/.local/bin $HOME/.config/dotfiles/bin

set -gx EDITOR nvim
set -gx TERMINAL kitty
set -gx BROWSER firefox
set -gx PAGER /usr/bin/less

# Python
set -gx PIP_REQUIRE_VIRTUALENV true
set -gx PYTHONDONTWRITEBYTECODE 1

# Build (cache nproc result for performance)
if not set -q MAKEFLAGS
    set -Ux MAKEFLAGS "-j"(nproc)
end

# XDG fixes for non-compliant tools
set -gx ANSIBLE_LOCAL_TEMP ~/.cache/ansible/tmp
set -gx ANSIBLE_SSH_CONTROL_PATH_DIR ~/.cache/ansible/cp
set -gx BUNDLE_USER_CACHE "$XDG_CACHE_HOME/bundle"
set -gx BUNDLE_USER_CONFIG "$XDG_CONFIG_HOME/bundle/config"
set -gx BUNDLE_USER_PLUGIN "$XDG_DATA_HOME/bundle"
set -gx CARGO_HOME "$XDG_DATA_HOME/cargo"
set -gx HTTPIE_CONFIG_DIR "$XDG_CONFIG_HOME/httpie"
set -gx KUBECACHEDIR "$XDG_CACHE_HOME/kube"
set -gx KUBECONFIG "$XDG_CONFIG_HOME/kube"
set -gx LESSHISTFILE "$XDG_CACHE_HOME/less/lesshist"
set -gx NPM_CONFIG_USERCONFIG "$XDG_CONFIG_HOME/npm/npmrc"
set -gx PARALLEL_HOME "$XDG_CONFIG_HOME/parallel"
set -gx PASSWORD_STORE_DIR "$XDG_DATA_HOME/password-store"
set -gx PYTHONPYCACHEPREFIX "$XDG_CACHE_HOME/python"
set -gx PYTHONUSERBASE "$XDG_DATA_HOME/python"
set -gx PYTHON_HISTORY "$XDG_STATE_HOME/python_history"
set -gx RUSTUP_HOME "$XDG_DATA_HOME/rustup"
set -gx TMUX_TMPDIR "$XDG_RUNTIME_DIR"
