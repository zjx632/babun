#!/bin/bash
set -e -f -o pipefail
source "/usr/local/etc/babun.instance"

# shellcheck source=/usr/local/etc/babun/source/babun-core/tools/script.sh
source "$babun_tools/script.sh"
# shellcheck source=/usr/local/etc/babun/source/babun-core/tools/plugins.sh
source "$babun_tools/plugins.sh"

usage() {
    local msg="\
shell-here plugin commands are subcommands for babun

Usage:
    shell-here install
    shell-here init     *DEPRECATED*
    shell-here uninstall
    shell-here remove   *DEPRECATED*
    shell-here --help
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

    install | init)
        plugin_install_home "shell-here"
        ;;

    uninstall | remove)
        plugin_uninstall "shell-here"
        ;;

    *)
        usage ; exit 0 ;;
esac
