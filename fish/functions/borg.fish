function borg --wraps borg
    if command -q pass
        BORG_PASSCOMMAND="pass show server/cord/borgbackup" command borg $argv
    else
        command borg $argv
    end
end
