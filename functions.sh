# ================================================================
# iTerm2 tab color functions
#
# Author: Connor de la Cruz (connor.c.delacruz@gmail.com)
# Repo: https://github.com/connordelacruz/iterm2-tab-color
# ================================================================

# Set the tab color
i2c() {
    # takes 1 hex string argument or 3 hex values for RGB
    local R G B
    case "$#" in
        3)
            R="$1"
            G="$2"
            B="$3"
            ;;
        1)
            local hex="$1"
            # Remove leading # if present
            if [[ "${hex:0:1}" == "#" ]]; then
                hex="${hex:1}"
            fi
            # Get hex values for each channel and convert to decimal
            R="$((16#${hex:0:2}))"
            G="$((16#${hex:2:2}))"
            B="$((16#${hex:4}))"
            ;;
        *)
            R="$((RANDOM % 255))"
            G="$((RANDOM % 255))"
            B="$((RANDOM % 255))"
            ;;
    esac
    echo -ne "\033]6;1;bg;red;brightness;$R\a"
    echo -ne "\033]6;1;bg;green;brightness;$G\a"
    echo -ne "\033]6;1;bg;blue;brightness;$B\a"
    # Export environment variable to maintain colors during session
    export IT2_SESSION_COLOR="$R $G $B"
}

# Reset tab color to default
i2r() {
    echo -ne "\033]6;1;bg;*;default\a"
    # Unset environment variable
    unset IT2_SESSION_COLOR
}

# Check for ~/.base16_theme and set the tab color based on that
i2b16() {
    if [ -f "$HOME/.base16_theme" ]; then
        local colornum color
        # If no argument was passed, default to color00
        if [ "$#" -lt 1 ]; then
            colornum="00"
        else
            # Add leading 0 if necessary
            colornum="$(printf "%02d" $1)"
        fi
        color="$(perl -nle "print \$& if m{color$colornum=\"\K.*(?=\")}" "$HOME/.base16_theme")"
        i2c ${color///}
    fi
}

# Restore session tab color
if [ -n "$IT2_SESSION_COLOR" ]; then
    i2c $IT2_SESSION_COLOR
fi

