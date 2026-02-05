function worktree --description "Create a git worktree and copy/symlink untracked config files"
    argparse -n worktree h/help v/verbose -- $argv
    or return

    # ── File patterns to copy to new worktrees ──────────────────────
    set -l copy_patterns \
        '.envrc' \
        '.env' \
        '.env.local' \
        '.tool-versions' \
        '.mise.toml' \
        'local' \
        '*.cfg' \
        'settings.local.json'

    # ── File/directory patterns to symlink into new worktrees ───────
    set -l symlink_patterns \
        'CLAUDE.md' \
        '.claude' \
        '.beads'

    if set -q _flag_help; or test (count $argv) -eq 0
        echo "worktree [-v] <branch name>"
        echo
        echo "Create a git worktree with <branch name>. Will create a worktree"
        echo "if one isn't found that matches the given name."
        echo
        echo "Copies and symlinks untracked config files to the new worktree."
        echo "  Copied:    "(string join ', ' $copy_patterns)
        echo "  Symlinked: "(string join ', ' $symlink_patterns)
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

    # Build find arguments for copy patterns
    set -l copy_find_args -iname $copy_patterns[1]
    for p in $copy_patterns[2..]
        set -a copy_find_args -o -iname $p
    end

    # Copy untracked config files to the new worktree
    for f in (find . -not -path '*node_modules*' \( $copy_find_args \))
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

    # Build find arguments for symlink patterns
    set -l symlink_find_args -iname $symlink_patterns[1]
    for p in $symlink_patterns[2..]
        set -a symlink_find_args -o -iname $p
    end

    # Find the main branch worktree for symlinking
    set -l main_worktree
    set -l _wt_path
    for line in (command git worktree list --porcelain)
        if string match -q 'worktree *' -- $line
            set _wt_path (string replace 'worktree ' '' -- $line)
        else if string match -q 'branch refs/heads/main' -- $line
            or string match -q 'branch refs/heads/master' -- $line
            set main_worktree $_wt_path
            break
        end
    end
    if test -z "$main_worktree"
        set_color yellow
        echo "Could not find main branch worktree, symlinking from current directory"
        set_color normal
        set main_worktree (pwd)
    end

    # Symlink files/directories from main branch worktree
    for f in (find $main_worktree -maxdepth 2 -not -path '*node_modules*' \( $symlink_find_args \) -printf '%P\n')
        set -l target ../$dirname/$f
        mkdir -p (dirname $target)
        # Remove existing file/directory so ln doesn't symlink *into* it
        if test -e $target; or test -L $target
            rm -rf $target
        end
        ln -s $main_worktree/$f $target
        or begin
            set_color yellow
            echo "Unable to symlink $f"
            set_color normal
        end
        if set -q _flag_verbose
            echo "Symlinked $f"
        end
    end

    cd ../$dirname
    set_color green
    echo "Created worktree ../$dirname"
    set_color normal
end
