function worktree --description "Create a git worktree and copy untracked config files"
    argparse -n worktree h/help v/verbose -- $argv
    or return

    if set -q _flag_help; or test (count $argv) -eq 0
        echo "worktree [-v] <branch name>"
        echo
        echo "Create a git worktree with <branch name>. Will create a worktree"
        echo "if one isn't found that matches the given name."
        echo
        echo "Copies .env, .envrc, .tool-versions, .cfg, CLAUDE.md, and"
        echo "settings.local.json files to the new worktree."
        return 0
    end

    set -l branchname $argv[1]
    set -l dirname (string replace -a / _ $branchname)

    # Pull the most recent version of the remote
    if not command git pull
        set_color yellow
        echo "Unable to run git pull, there may not be an upstream"
        set_color normal
    end

    # Check if branch exists locally or on remote, then create worktree
    set -l local_branches (command git for-each-ref --format='%(refname:lstrip=2)' refs/heads)
    set -l remote_branches (command git for-each-ref --format='%(refname:lstrip=3)' refs/remotes/origin)

    if contains $branchname $local_branches; or contains $branchname $remote_branches
        if not command git worktree add ../$dirname $branchname
            set_color red
            echo "Failed to create git worktree $branchname"
            set_color normal
            return 1
        end
    else
        if not command git worktree add -b $branchname ../$dirname
            set_color red
            echo "Failed to create git worktree $branchname"
            set_color normal
            return 1
        end
    end

    # Copy node_modules with copy-on-write if present
    if test -d node_modules
        /bin/cp -R --reflink=auto node_modules ../$dirname/node_modules
        or set_color yellow; and echo "Unable to copy node_modules"; and set_color normal
    end

    # Copy untracked config files to the new worktree
    for f in (find . -not -path '*node_modules*' \( \
            -name '.envrc' -o \
            -name '.env' -o \
            -name '.env.local' -o \
            -name '.tool-versions' -o \
            -name '.mise.toml' -o \
            -name 'local' -o \
            -name '*.cfg' -o \
            -iname 'CLAUDE.md' -o \
            -iname 'settings.local.json' \
        \))
        mkdir -p (dirname ../$dirname/$f)
        /bin/cp -R --reflink=auto $f ../$dirname/$f
        or begin
            set_color yellow
            echo "Unable to copy $f"
            set_color normal
        end
        if set -q _flag_verbose
            echo "Copied $f"
        end
    end

    cd ../$dirname
    set_color green
    echo "Created worktree ../$dirname"
    set_color normal
end
