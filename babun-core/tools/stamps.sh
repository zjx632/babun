#!/bin/bash
source "/usr/local/etc/babun.instance"
# shellcheck source=/usr/local/etc/babun/source/babun-core/tools/script.sh
source "$babun_tools/script.sh"
stamps="$babun/stamps"

if ! [ -d "$stamps" ]; then
    mkdir -p "$stamps"
fi
