function unworktree --description "Remove a git worktree, delete its branch, and close its pxtx issue"
    argparse -n unworktree h/help f/force k/keep-issue -- $argv
    or return

    if set -q _flag_help; or test (count $argv) -eq 0
        echo "unworktree [-f] [-k] <branch name>"
        echo
        echo "Remove the worktree for <branch name>, delete the branch, and"
        echo "close the matching pxtx issue if the branch is named px-<number>."
        echo
        echo "  -f/--force       pass --force to git worktree remove"
        echo "  -k/--keep-issue  do not close the pxtx issue"
        return 0
    end

    set -l branchname $argv[1]
    set -l original_dir $PWD

    # Locate the worktree for the branch and the main worktree to return to.
    set -l worktree_path
    set -l main_worktree
    set -l _wt_path
    for line in (command git worktree list --porcelain)
        if string match -q 'worktree *' -- $line
            set _wt_path (string replace 'worktree ' '' -- $line)
        else if test "$line" = "branch refs/heads/$branchname"
            set worktree_path $_wt_path
        else if test "$line" = "branch refs/heads/main"; or test "$line" = "branch refs/heads/master"
            set main_worktree $_wt_path
        end
    end

    if test -z "$main_worktree"
        set_color red
        echo "Could not find a main or master worktree"
        set_color normal
        return 1
    end

    cd $main_worktree

    if not command git pull
        set_color yellow
        echo "Unable to run git pull, there may not be an upstream"
        set_color normal
    end

    if test -n "$worktree_path"
        # temp-results only holds throwaway screenshots, and its presence makes
        # git worktree remove complain about untracked files.
        if test -d "$worktree_path/temp-results"
            rm -rf "$worktree_path/temp-results"
        end

        set -l remove_args
        if set -q _flag_force
            set remove_args --force
        end
        if not command git worktree remove $remove_args $worktree_path
            set_color red
            echo "Failed to remove worktree $worktree_path"
            set_color normal
            _unworktree_restore_dir $original_dir
            return 1
        end
        set_color green
        echo "Removed worktree $worktree_path"
        set_color normal
    else
        set_color yellow
        echo "No worktree found for $branchname"
        set_color normal
    end

    if not command git branch -D $branchname
        set_color red
        echo "Failed to delete branch $branchname"
        set_color normal
        _unworktree_restore_dir $original_dir
        return 1
    end

    # Branches named px-<number>-something track a pxtx issue; close it.
    set -l issue (string match -rg '^px-(\d+)' -- $branchname)
    if test -n "$issue"; and not set -q _flag_keep_issue
        if command pxtx issue close $issue
            set_color green
            echo "Closed pxtx issue $issue"
            set_color normal
        else
            set_color yellow
            echo "Unable to close pxtx issue $issue"
            set_color normal
        end
    end

    _unworktree_restore_dir $original_dir
end

function _unworktree_restore_dir --description "Return to the directory unworktree was called from, if it still exists"
    # The starting directory is gone when it was inside the removed worktree;
    # in that case we stay in the main worktree.
    if test -d "$argv[1]"
        cd $argv[1]
    end
end
