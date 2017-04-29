#!/bin/bash
set -e -f -o pipefail
source "/usr/local/etc/babun.instance"

# shellcheck source=/usr/local/etc/babun/source/babun-core/tools/script.sh
source "$babun_tools/script.sh"
# shellcheck source=/usr/local/etc/babun/source/babun-core/tools/plugins.sh
source "$babun_tools/plugins.sh"

usage() {
    local msg="\
pact plugin commands are subcommands for babun

Usage:
    pact install
    pact --help
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
        plugin_install "pact"
        plugin_install_home "pact"
        ;;

    *)
        usage ; exit 0 ;;
esac
