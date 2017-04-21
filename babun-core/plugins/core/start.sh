#!/bin/bash
source "/usr/local/etc/babun.instance"

if ! [[ "$DISABLE_CHECK_ON_STARTUP" == "true" ]]; then
    # shellcheck source=/usr/local/etc/babun/source/babun-core/tools/check.sh
    source "$babun_tools/check.sh"
    guarded_babun_check
    trap - DEBUG ERR
    trap
fi
