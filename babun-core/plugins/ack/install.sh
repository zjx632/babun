#!/bin/bash
set -e -f -o pipefail
source "/usr/local/etc/babun.instance"
# shellcheck source=/usr/local/etc/babun/source/babun-core/tools/script.sh
source "$babun_tools/script.sh"

if [[ "$DISABLE_PLUGIN_ACK" == "true" ]]; then
    return 0
fi

tar -C "$babun_plugins/ack/src/" -xf "$babun_plugins/ack/src/ack-214-single.tar"
/bin/cp -rf "$babun_plugins/ack/src/ack-214-single" /usr/local/bin/ack
chmod 755 /usr/local/bin/ack
