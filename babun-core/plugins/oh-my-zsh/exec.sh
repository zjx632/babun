#!/bin/bash
set -e -f -o pipefail
source "/usr/local/etc/babun.instance"

# shellcheck source=/usr/local/etc/babun/source/babun-core/tools/script.sh
source "$babun_tools/script.sh"
# shellcheck source=/usr/local/etc/babun/source/babun-core/tools/plugins.sh
source "$babun_tools/plugins.sh"

usage() {
    local msg="\
oh-my-zsh plugin commands are subcommands for babun

Usage:
    oh-my-zsh install
    oh-my-zsh --help
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
        plugin_install "oh-my-zsh"
        plugin_install_home "oh-my-zsh"
        ;;

    *)
        usage ; exit 0 ;;
esac
