#!/bin/bash
set -e -f -o pipefail
source "/usr/local/etc/babun.instance"
# shellcheck source=/usr/local/etc/babun/source/babun-core/tools/script.sh
source "$babun_tools/script.sh"


run() {
    rm -f "$homedir/.XWinrc"
    rm -f "$homedir/.Xresources"
    rm -f "$homedir/.startxwinrc"
    rm -rf "$babun/home/xserver"
    pact remove xorg-server xinit xorg-docs
}

run
