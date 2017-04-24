#!/bin/bash
set -e -f -o pipefail
source "/usr/local/etc/babun.instance"
# shellcheck source=/usr/local/etc/babun/source/babun-core/tools/script.sh
source "$babun_tools/script.sh"

src="$babun/home/pact"

# if pact not installed
if [ ! -d "$homedir/.pact" ]; then
    # installing pact
    /bin/cp -rf "$src/.pact" "$homedir/.pact"
fi
