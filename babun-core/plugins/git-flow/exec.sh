#!/bin/bash
set -e -f -o pipefail
source "/usr/local/etc/babun.instance"

# shellcheck source=/usr/local/etc/babun/source/babun-core/tools/script.sh
source "$babun_tools/script.sh"
# shellcheck source=/usr/local/etc/babun/source/babun-core/tools/plugins.sh
source "$babun_tools/plugins.sh"

usage() {
    local msg="\
git-flow plugin commands are subcommands for babun

Usage:
    git-flow install
    git-flow uninstall
    git-flow --help
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
        plugin_install "git-flow"
        plugin_install_home "git-flow"
        ;;

    uninstall)
        plugin_uninstall "git-flow"
        ;;

    *)
        usage ; exit 0 ;;
esac
