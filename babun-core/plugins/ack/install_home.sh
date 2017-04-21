#!/bin/bash
set -e -f -o pipefail
source "/usr/local/etc/babun.instance"
# shellcheck source=/usr/local/etc/babun/source/babun-core/tools/script.sh
source "$babun_tools/script.sh"

tar -C "$homedir/.vim" -xf "$babun_plugins/ack/src/ack-vim/ack.tar"
