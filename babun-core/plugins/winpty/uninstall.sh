#!/bin/bash
set -e -f -o pipefail
source "/usr/local/etc/babun.instance"
# shellcheck source=/usr/local/etc/babun/source/babun-core/tools/script.sh
source "$babun_tools/script.sh"


run() {
    local state_dir="$babun/external/winpty"

    if [ ! -f "$state_dir/installed" ]; then
        echo "winpty install state is unknown; skipping uninstall"
        return 1
    fi

    awk '/[^\/]$/ {print "rm -f \"" $0 "\""}' "$state_dir/installed" | sh
    rm -f "$state_dir/installed"
}

run
