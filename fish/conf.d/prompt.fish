##########
# Prompt #
##########

# Powerline separator (U+E0B0)
set -g SEGMENT_SEPARATOR \ue0b0

# 256-color palette indices - uses terminal's palette
set -g PROMPT_COLOUR 6

# Host color pairs: "bg fg" per line - run fish/scripts/select-host-colours.py to regenerate
# User (non-root) colors
set -g USER_HOST_PAIRS \
    10 15 \
    12 15 \
    14 15 \
    23 15 \
    30 15 \
    31 15 \
    35 15 \
    36 15 \
    37 15 \
    66 15 \
    73 15 \
    108 15 \
    244 15 \
    245 15 \
    246 15 \
    71 15

# Root colors
set -g ROOT_HOST_PAIRS \
    9 15 \
    124 15 \
    131 15 \
    132 15 \
    160 15 \
    161 15 \
    166 15 \
    167 15 \
    168 15 \
    196 15 \
    197 15 \
    202 0 \
    203 0

# Cache user info (constant for shell lifetime)
set -g USER_NAME (whoami)
set -g USER_ID (id -u)

# Hostname (universal, persists across shells, per-user)
# Erase any inherited/exported global to avoid shadowing the universal
set -eg HOST_STRING
if not set -qU HOST_STRING
    set -U HOST_STRING (hostnamectl hostname 2>/dev/null || hostname)
end

# Hash hostname to get a consistent color per host
# Uses separate palettes for root vs non-root users
set -l hash_hex (echo -n $HOST_STRING | sha1sum | cut -d ' ' -f 1 | head -c 8)
set -l hash_val (printf '%d' 0x$hash_hex)

if test $USER_ID -eq 0
    set -l pair_count (math (count $ROOT_HOST_PAIRS) / 2)
    set -l pair_index (math "$hash_val % $pair_count * 2")
    set -g HOST_COLOUR $ROOT_HOST_PAIRS[(math "$pair_index + 1")]
    set -g HOST_FG $ROOT_HOST_PAIRS[(math "$pair_index + 2")]
else
    set -l pair_count (math (count $USER_HOST_PAIRS) / 2)
    set -l pair_index (math "$hash_val % $pair_count * 2")
    set -g HOST_COLOUR $USER_HOST_PAIRS[(math "$pair_index + 1")]
    set -g HOST_FG $USER_HOST_PAIRS[(math "$pair_index + 2")]
end
