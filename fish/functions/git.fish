function git --description "Wrap git to show status after common commands" --wraps git
    set -l auto_status_commands add rm reset commit checkout mv push pull
    command git $argv
    set -l git_status $status

    # Check if first argument is in auto_status_commands
    if contains $argv[1] $auto_status_commands
        command git status --short --branch
    end

    return $git_status
end
