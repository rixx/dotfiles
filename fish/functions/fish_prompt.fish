# Helper functions for 256-color support via ANSI escapes
function _fg --argument-names color
    printf '\e[38;5;%sm' $color
end

function _bg --argument-names color
    printf '\e[48;5;%sm' $color
end

function _reset
    printf '\e[0m'
end

function fish_prompt
    set -l last_status $status
    set -l current_bg ""

    # Newline before prompt
    echo

    # Status indicators (error, root, jobs)
    set -l status_icons
    if test $last_status -ne 0
        set -a status_icons (_fg 1)"✘"
    end
    if test $USER_ID -eq 0
        set -a status_icons (_fg 3)"⚡"
    end
    if test (jobs | count) -gt 0
        set -a status_icons (_fg 6)"⚙"
    end
    if test (count $status_icons) -gt 0
        _bg $PROMPT_COLOUR
        echo -n " $status_icons "
        set current_bg $PROMPT_COLOUR
    end

    # Segment separator from status to context
    if test -n "$current_bg"
        _bg $HOST_COLOUR
        _fg $current_bg
        echo -n $SEGMENT_SEPARATOR
    end

    # Context: user@hostname
    _bg $HOST_COLOUR
    _fg $HOST_FG
    echo -n " $USER_NAME@$HOST_STRING "
    set current_bg $HOST_COLOUR

    # Directory (with git info if in repo)
    if git rev-parse --is-inside-work-tree >/dev/null 2>&1
        set -l git_root (git rev-parse --show-toplevel)
        set -l git_prefix (git rev-parse --show-prefix 2>/dev/null)
        set -l git_branch (git rev-parse --abbrev-ref HEAD 2>/dev/null)

        # Separator to path segment
        _bg $PROMPT_COLOUR
        _fg $current_bg
        echo -n $SEGMENT_SEPARATOR

        # Show git root path
        _fg 15
        echo -n " "(string replace $HOME "~" $git_root)" "
        set current_bg $PROMPT_COLOUR

        # Git status - get full status once and use it for both dirty check and indicators
        set -l git_index (git status --porcelain -b --ignore-submodules=dirty 2>/dev/null)
        # Check if dirty (without untracked, matching zsh behavior)
        set -l is_dirty (echo "$git_index" | string match -rv '^\?\? |^## ')
        set -l dirty_mark

        if test -n "$is_dirty"
            # Dirty - yellow background (222)
            _bg 222
            _fg $current_bg
            echo -n $SEGMENT_SEPARATOR
            _fg 0
            set dirty_mark " ✘ "
            set current_bg 222
        else
            # Clean - white background (7)
            _bg 7
            _fg $current_bg
            echo -n $SEGMENT_SEPARATOR
            _fg 0
            set dirty_mark " ✔ "
            set current_bg 7
        end

        # Branch name
        if test "$git_branch" = "HEAD"
            set git_branch "➦ "(git show-ref --head -s --abbrev | head -n1)
        else
            set git_branch (printf " \ue0a0 %s" $git_branch)
        end
        echo -n "$git_branch$dirty_mark"

        # Detailed git status indicators
        set -l git_indicators ""
        # Untracked
        if echo "$git_index" | string match -rq '^\?\? '
            set git_indicators $git_indicators(_fg 6)"✲"
        end
        # Added/Staged
        if echo "$git_index" | string match -rq '^[AM] '
            set git_indicators $git_indicators(_fg 2)"✚"
        end
        # Modified
        if echo "$git_index" | string match -rq '^.M |^ M '
            set git_indicators $git_indicators(_fg 4)"✸"
        end
        # Renamed
        if echo "$git_index" | string match -rq '^R '
            set git_indicators $git_indicators(_fg 1)"➜"
        end
        # Deleted
        if echo "$git_index" | string match -rq '^.D |^ D |^D '
            set git_indicators $git_indicators(_fg 1)"✖"
        end
        # Unmerged
        if echo "$git_index" | string match -rq '^UU '
            set git_indicators $git_indicators(_fg 1)"↮"
        end
        # Ahead
        if echo "$git_index" | string match -rq 'ahead'
            set git_indicators $git_indicators(_fg 15)"⬆"
        end
        # Behind
        if echo "$git_index" | string match -rq 'behind'
            set git_indicators $git_indicators(_fg 1)"⬇"
        end
        # Stashed
        if git rev-parse --verify refs/stash >/dev/null 2>&1
            set git_indicators $git_indicators(_fg 4)"♻"
        end
        if test -n "$git_indicators"
            _fg 0
            echo -n " $git_indicators"
        end
        echo -n " "

        # Current subdirectory within repo (always show / even at root)
        _bg $PROMPT_COLOUR
        _fg $current_bg
        echo -n $SEGMENT_SEPARATOR
        _fg 15
        echo -n " /$git_prefix "
        set current_bg $PROMPT_COLOUR
    else
        # Separator to path segment
        _bg $PROMPT_COLOUR
        _fg $current_bg
        echo -n $SEGMENT_SEPARATOR

        # Not in git repo - just show directory
        _fg 15
        echo -n " "(prompt_pwd)" "
        set current_bg $PROMPT_COLOUR
    end

    # End first line
    _reset
    _fg $current_bg
    echo -n $SEGMENT_SEPARATOR
    _reset
    echo

    # Second line with prompt symbol
    _bg $PROMPT_COLOUR
    _fg 15
    echo -n "  "
    _reset
    _fg $PROMPT_COLOUR
    echo -n $SEGMENT_SEPARATOR
    _reset
    echo -n " "
end

function fish_right_prompt
    # Empty right prompt
end
