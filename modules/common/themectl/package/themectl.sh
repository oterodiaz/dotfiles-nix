#!/usr/bin/env sh

eprintf() {
    printf "$@" 1>&2
}

usage() {
    eprintf 'Usage: %s [-h] [-g] [-d] [-l] [-t]\n\n' "$(basename "$0")"
    eprintf 'Options:\n'
    eprintf -- '-h\tShow this message\n'
    eprintf -- '-g\tGet the dark mode status: returns 0 when dark mode is enabled, 1 otherwise (default behavior)\n'
    eprintf -- '-d\tSwitch to dark mode\n'
    eprintf -- '-l\tSwitch to light mode\n'
    eprintf -- '-t\tToggle between dark and light mode\n'
    eprintf -- "-u\tUpdate the theme in applications that don't do so automatically (vim, fish, etc.)\n"
}

if [ "$#" -eq 0 ]; then
    GET=1
fi

while getopts ':hgdltu' OPTION; do
    case "$OPTION" in
        h)
            usage 2>&1
            exit 0
            ;;
        g)
            GET=1
            ;;
        d)
            DARK=1
            ;;
        l)
            LIGHT=1
            ;;
        t)
            TOGGLE=1
            ;;
        u)
            UPDATE=1
            ;;
        *)
            usage
            exit 1
            ;;
    esac
done

# Ensure that only one option is provided
shift "$((OPTIND -1))"
if [ "$#" -ne 0 ]; then
    usage
    exit 1
fi

get_status() {
    if [ "$(uname -s)" = "Darwin" ]; then
        defaults read -g AppleInterfaceStyle > /dev/null 2>&1
    else
        gsettings get org.gnome.desktop.interface color-scheme | grep -qo "prefer-dark"
    fi
}

# Updates tools that aren't synced with the OS theme
update_theme() {
    if command -v nvim-update-theme > /dev/null 2>&1; then
        "nvim-update-theme" &
    fi

    if command -v fish > /dev/null 2>&1; then
        fish -c "colorscheme '$FISH_THEME'" &
    fi

    # if pgrep 'Emacs' > /dev/null 2>&1; then
    #     emacsclient --no-wait --eval "(load-theme (get-correct-theme))"
    # fi
} > /dev/null 2>&1

set_theme() {
    if [ "$(uname -s)" = "Darwin" ]; then
        osascript -e 'tell app "System Events" to tell appearance preferences to set dark mode to '"$DARK_MODE"''
    else
        if [ "$DARK_MODE" = 'true' ]; then
            gsettings set org.gnome.desktop.interface color-scheme "prefer-dark"
        else
            gsettings set org.gnome.desktop.interface color-scheme "default"
        fi
    fi

    update_theme
}

light_config() {
    DARK_MODE='false'
    FISH_THEME='tomorrow-day'
}

dark_config() {
    DARK_MODE='true'
    FISH_THEME='tomorrow-night'
}

if [ -n "${GET+x}" ]; then
    get_status
elif [ -n "${UPDATE+x}" ]; then
    if get_status; then
        dark_config
    else
        light_config
    fi
    update_theme
elif [ -n "${TOGGLE+x}" ]; then
    if get_status; then
        light_config
    else
        dark_config
    fi
    set_theme
elif [ -n "${DARK+x}" ]; then
    dark_config
    set_theme
elif [ -n "${LIGHT+x}" ]; then
    light_config
    set_theme
fi
