#!/bin/bash
set -e -f -o pipefail
source "/usr/local/etc/babun.instance"
# shellcheck source=/usr/local/etc/babun/source/babun-core/tools/script.sh
source "$babun_tools/script.sh"


run() {
    local src="$babun/home/shell/"

    # if vim not installed
    if [[ ! -d "$homedir/.vim" ]]; then
        /bin/cp -rf "$src/.vim" "$homedir/.vim"
        tar -C "$homedir/.vim" -xf "$src/.vim/colors.tar"
    fi

    if [[ ! -f "$homedir/.minttyrc" ]]; then
        touch "$homedir/.minttyrc"
    fi
}

run
