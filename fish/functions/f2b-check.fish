function f2b-check
    set -l ip $argv[1]
    if test -z "$ip"
        echo "usage: f2b-check <ip>"
        return 1
    end

    sudo sqlite3 /var/lib/fail2ban/fail2ban.sqlite3 \
        "SELECT jail, datetime(timeofban, 'unixepoch', 'localtime'), bantime FROM bans WHERE ip = '$ip' ORDER BY timeofban DESC;" \
    | while read -d '|' jail bantime_str bantime
        if test "$bantime" -eq 0
            set remaining "permanent"
        else
            set expires (math (date -d "$bantime_str" +%s) + $bantime)
            set now (date +%s)
            set left (math $expires - $now)
            if test $left -le 0
                set remaining "expired"
            else
                set h (math --scale=0 $left / 3600)
                set m (math --scale=0 $left % 3600 / 60)
                set remaining "$h"h" $m"m" remaining"
            end
        end
        echo "$jail: banned $bantime_str ($remaining)"
    end
end
