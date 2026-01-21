###################
# Colored man pages
###################

# Set LESS_TERMCAP variables for colored man pages
set -gx LESS_TERMCAP_mb \e'[1;31m'      # begin bold (red)
set -gx LESS_TERMCAP_md \e'[1;31m'      # begin bold (red)
set -gx LESS_TERMCAP_me \e'[0m'         # reset
set -gx LESS_TERMCAP_so \e'[1;33;44m'   # begin standout (yellow on blue)
set -gx LESS_TERMCAP_se \e'[0m'         # reset standout
set -gx LESS_TERMCAP_us \e'[1;32m'      # begin underline (green)
set -gx LESS_TERMCAP_ue \e'[0m'         # reset underline
set -gx GROFF_NO_SGR 1
