#!/bin/sh

# Create crontab with BORG_PASSPHRASE
# export BORG_PASSPHRASE='XYZl0ngandsecurepa_55_phrasea&&123'

# export BORG_REPO=ssh://username@example.com:2022/~/backup/main
export BORG_REPO=/backup/cordelia

# some helpers and error handling:
info() { printf "\n%s %s\n\n" "$( date )" "$*" >&2; }
trap 'echo $( date ) Backup interrupted >&2; exit 2' INT TERM

info "Starting backup"

# Backup the most important directories into an archive named after
# the machine this script is currently running on:
/usr/bin/borg create                \
    --verbose                       \
    --filter AME                    \
    --stats                         \
    --list                          \
    --compression lz4               \
    --exclude-caches                \
    --exclude '*/node_modules'      \
    --exclude '*/static.dist'       \
    --exclude '*/vendor/bundle'     \
    ::'{hostname}-{now}'        \
    ~/.local/share/mail                         \
    ~/.local/share/password-store               \
    ~/.local/share/zsh                          \
    ~/.local/share/applications/mimeapps.list   \
    ~/.local/share/com.github.alainm23.planner  \
    ~/.gnupg                                    \
    ~/.mozilla                                  \
    ~/.ssh                                      \
    ~/.stepmania-5.1                            \
    ~/doc                                       \
    ~/src                                       \
    ~/lib/pics                                  \
    ~/lib/sound                                 \
    ~/lib/books                                 \
    ~/lib/movies                                \
    ~/Downloads


backup_exit=$?

info "Pruning repository"

# Use the `prune` subcommand to maintain 7 daily, 4 weekly and 6 monthly
# archives of THIS machine. The '{hostname}-' prefix is very important to
# limit prune's operation to this machine's archives and not apply to
# other machines' archives also:

/usr/bin/borg prune                 \
    --list                          \
    --prefix '{hostname}-'          \
    --show-rc                       \
    --keep-daily    7               \
    --keep-weekly   4               \
    --keep-monthly  6               \

prune_exit=$?

# use highest exit code as global exit code
global_exit=$(( backup_exit > prune_exit ? backup_exit : prune_exit ))

if [ ${global_exit} -eq 0 ]; then
    info "Backup and Prune finished successfully"
elif [ ${global_exit} -eq 1 ]; then
    info "Backup and/or Prune finished with warnings"
else
    info "Backup and/or Prune finished with errors"
fi

exit ${global_exit}
