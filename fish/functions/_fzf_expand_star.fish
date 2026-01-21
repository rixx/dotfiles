function _fzf_expand_star --description "Expand ** to fzf file selection"
    set -l cmd (commandline)
    set -l cursor (commandline -C)
    # Check if the text before cursor ends with **
    set -l before (string sub -l $cursor -- $cmd)
    if string match -rq '\*\*$' -- $before
        set -l prefix (string replace -r '\*\*$' '' -- $before)
        set -l after (string sub -s (math $cursor + 1) -- $cmd)
        # Get fzf selection
        set -l selection (fzf -m | string join ' ')
        if test -n "$selection"
            commandline -r "$prefix$selection$after"
            commandline -C (math (string length "$prefix$selection"))
        else
            # User cancelled, restore without **
            commandline -r "$prefix$after"
            commandline -C (string length $prefix)
        end
    else
        # No **, do normal tab completion
        commandline -f complete
    end
end
