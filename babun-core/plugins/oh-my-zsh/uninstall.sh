#!/bin/bash
set -e -f -o pipefail
source "/usr/local/etc/babun.instance"
# shellcheck source=/usr/local/etc/babun/source/babun-core/tools/script.sh
source "$babun_tools/script.sh"


run() {
    rm -rf "$babun/external/oh-my-zsh"
    rm -rf "$babun/home/oh-my-zsh/.oh-my-zsh"
    rm -rf "$homedir/.oh-my-zsh"
}

run
