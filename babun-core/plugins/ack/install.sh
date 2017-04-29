#!/bin/bash
set -e -f -o pipefail
source "/usr/local/etc/babun.instance"
# shellcheck source=/usr/local/etc/babun/source/babun-core/tools/script.sh
source "$babun_tools/script.sh"


run() {
    if [[ "$DISABLE_PLUGIN_ACK" == "true" ]]; then
        echo "ack plugin is currently disabled; check ~/.babunrc to enable"
        return 0
    fi

    local source=https://beyondgrep.com/ack-2.18-single-file
    local bin=/usr/local/bin/ack

    # download the file and make executable
    wget -O "$bin" "$source"
    chmod 755 "$bin"

    # make sure it is there and being found as part of the path
    echo "# exectuable:"
    which ack
}

run
