# completions for ,pplugin
complete -c ',pplugin' -f
complete -c ',pplugin' -n '__fish_use_subcommand' -s c -l cookiecutter -d 'include the cookiecutter template'
complete -c ',pplugin' -n '__fish_use_subcommand' -a list -d 'print each maintained plugin and its location'
complete -c ',pplugin' -n '__fish_use_subcommand' -a all -d 'run a command in every plugin repo'
complete -c ',pplugin' -n '__fish_use_subcommand' -a status -d 'git status for every plugin'
complete -c ',pplugin' -n '__fish_use_subcommand' -a next -d 'cd to the next plugin repo'
