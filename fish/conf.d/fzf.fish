#######
# FZF #
#######

if type -q fzf
    if type -q fd
        set -gx FZF_DEFAULT_COMMAND 'fd --type f --hidden --follow --exclude .git'
        set -gx FZF_CTRL_T_COMMAND 'fd --type f --hidden --follow --exclude .git'
    end
    set -gx FZF_DEFAULT_OPTS '--inline-info --cycle --border --color=light'

    # Key bindings (Ctrl-R for history, Alt-C for cd, Ctrl-T for files)
    if test -f /usr/share/fish/vendor_functions.d/fzf_key_bindings.fish
        fzf_key_bindings
    else if type -q fzf_configure_bindings
        # fzf.fish plugin style
        fzf_configure_bindings
    end

    # ** expansion like zsh - bind Tab for expansion (falls back to normal completion if no **)
    bind \t _fzf_expand_star
end
