#!/usr/bin/env bash
# this copies seed profile to keep settings/extensions in a similar feature to "private browsing"
# but forgets history, cookies, data used/made during the session launched with this wrapper.

set -euo pipefail 
##################################### /REPLACE ME WITH YOUR ACTUAL PROFILE
SOURCE="$HOME/.config/mozilla/firefox/su3nv113.default-release"

TEMP_PROFILE=$(mktemp -d)

cleanup() {
    # nuke on exit
    rm -rf "$TEMP_PROFILE"
}

prepare() {
    # archive mode copy + no target directory 
    cp -aT "$SOURCE/" "$TEMP_PROFILE/"
}
# arm the trap, redirect stdout/stderr to devnull, background/disown so we keep the shell
# if launched from a shell... otherwise still works.
(
    trap cleanup EXIT INT TERM
    prepare && firefox --no-remote --profile "$TEMP_PROFILE" 1> /dev/null 2> /dev/null
) &
disown 
