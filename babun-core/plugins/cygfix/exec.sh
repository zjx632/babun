#!/bin/bash
set -e -f -o pipefail
source "/usr/local/etc/babun.instance"

# shellcheck source=/usr/local/etc/babun/source/babun-core/tools/script.sh
source "$babun_tools/script.sh"
# shellcheck source=/usr/local/etc/babun/source/babun-core/tools/plugins.sh
source "$babun_tools/plugins.sh"

usage() {
    local msg="\
cygfix plugin commands are subcommands for babun

Usage:
    cygfix install
    cygfix uninstall
    cygfix --help
"
    echo "$msg"
}

# Main processing of inputs
case $# in
  0) usage ; exit 0 ;;
esac

case $1 in
    --help)
        usage ; exit 0 ;;

    install)
        plugin_install "cygfix"
        ;;

    uninstall)
        plugin_uninstall "cygfix"
        ;;

    *)
        usage ; exit 0 ;;
esac
