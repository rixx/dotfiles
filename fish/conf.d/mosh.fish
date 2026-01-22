# Source moshrc when running under mosh
if test -f ~/.moshrc
    set -l parent_cmd (ps -o comm= -p (status --ppid) 2>/dev/null | string trim)
    if test "$parent_cmd" = mosh-server
        source ~/.moshrc
    end
end
