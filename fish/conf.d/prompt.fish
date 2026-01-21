##########
# Prompt #
##########

# Powerline separator (U+E0B0)
set -g SEGMENT_SEPARATOR \ue0b0

# 256-color palette indices - uses terminal's palette
set -g READABLE_COLOURS 9 14 23 30 35 36 37 65 66 71 72 95 96 101 107 109 130 131 132 166 167 172 173 235 236 237 238 244 245
set -g PROMPT_COLOUR 6

# Cache hostname string for prompt performance
if not set -q HOST_STRING
    set -Ux HOST_STRING (whoami)@(hostnamectl hostname 2>/dev/null || hostname)
end

# Hash username@hostname to get a consistent color (cached for performance)
if not set -q HOST_COLOUR
    set -l hash_hex (echo -n $HOST_STRING | sha1sum | cut -d ' ' -f 1 | head -c 8)
    set -l hash_val (printf '%d' 0x$hash_hex)
    set -l colour_count (count $READABLE_COLOURS)
    set -l colour_index (math "($hash_val % $colour_count) + 1")
    set -Ux HOST_COLOUR $READABLE_COLOURS[$colour_index]
end
