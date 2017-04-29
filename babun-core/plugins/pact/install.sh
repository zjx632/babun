#!/bin/bash
set -e -f -o pipefail
source "/usr/local/etc/babun.instance"
# shellcheck source=/usr/local/etc/babun/source/babun-core/tools/script.sh
source "$babun_tools/script.sh"

run() {
    local src="$babun_source/babun-core/plugins/pact/src"
    local dest="$babun/home/pact/.pact"

    cp -rf $src/pact /usr/local/bin
    chmod 755 /usr/local/bin/pact

    if [ ! -d "$dest" ]; then
        mkdir -p "$dest"
    fi

    if [ ! -f "$dest/pact.repo" ]; then
        cp "$src/pact.repo" "$dest"
    fi
}

run
