#!/bin/bash
set -e -f -o pipefail
source "/usr/local/etc/babun.instance"
# shellcheck source=/usr/local/etc/babun/source/babun-core/tools/script.sh
source "$babun_tools/script.sh"


run() {
    rm -f /usr/local/bin/ack
    rm -f "$homedir/.vim/plugin/ack.vim"
    rm -f "$homedir/.vim/doc/ack.txt"
    rm -f "$homedir/.vim/doc/ack_quick_help.txt"
}

run
