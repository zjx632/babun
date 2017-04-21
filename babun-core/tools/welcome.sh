#!/bin/bash
set -e -f -o pipefail
source "/usr/local/etc/babun/source/babun-core/tools/script.sh"
# shellcheck source=/usr/local/etc/babun/source/babun-core/tools/stamps.sh
source "$babun/source/babun-core/tools/stamps.sh"

welcome_stamp="/usr/local/etc/babun/stamps/welcome"
if ! [ -f "$welcome_stamp" ]; then
    babun --welcome
    echo ""
    date > "$welcome_stamp"
fi
