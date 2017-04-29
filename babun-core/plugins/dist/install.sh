#!/bin/bash
set -e -f -o pipefail
source "/usr/local/etc/babun.instance"
# shellcheck source=/usr/local/etc/babun/source/babun-core/tools/script.sh
source "$babun_tools/script.sh"


run() {
    local src="$babun_source/babun-dist"
    local babun_root
    babun_root=/cygdrive/$( cygpath -ma "/" | sed "s/://"g )/..

    # copy dist files to the dist folder
    cp -rf "$src/fonts" "$babun_root"
    cp -rf "$src/tools" "$babun_root"

    # copy scripts
    cp -rf "$src/start/update.bat" "$babun_root"
    cp -rf "$src/start/rebase.bat" "$babun_root"
    cp -rf "$src/start/uninstall.bat" "$babun_root"
}

run
