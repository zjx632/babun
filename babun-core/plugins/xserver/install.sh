#!/bin/bash
set -e -f -o pipefail
source "/usr/local/etc/babun.instance"
# shellcheck source=/usr/local/etc/babun/source/babun-core/tools/script.sh
source "$babun_tools/script.sh"

if [[ "$DISABLE_PLUGIN_XSERVER" == "true" ]]; then
    return 0
fi

src="$babun_source/babun-core/plugins/xserver/src/."
dest="$babun/home/xserver"

pact install xorg-server xinit xorg-docs

/bin/cp -rf "$src/" "$dest"
