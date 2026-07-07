function ',pplugin' --description 'manage owned pretalx plugins'
    # `next` has to change *this* shell's directory, which the uv script (a
    # subprocess) can't do, so we wrap it here. everything else is delegated
    # straight to the script. `command` forces the binary, not this function.
    set -l rest $argv
    while test (count $rest) -ge 1; and contains -- $rest[1] -c --cookiecutter
        set rest $rest[2..-1]
    end

    if test (count $rest) -ge 1; and test $rest[1] = next
        set -l dest (command ',pplugin' $argv)
        or return $status
        test -n "$dest"; and cd $dest
    else
        command ',pplugin' $argv
    end
end
