#!/bin/bash
set -e -f -o pipefail
source "/usr/local/etc/babun.instance"
# shellcheck source=/usr/local/etc/babun/source/babun-core/tools/script.sh
source "$babun_tools/script.sh"


run() {
    local arch=${PROCESSOR_ARCHITECTURE/AMD64/x86_64}
    local src="$babun_source/babun-core/plugins/dist"

    if [ "$arch" = "x86" ]; then
        echo "Fixing awk.exe"
        /bin/cp -rf /bin/awk /bin/awk.current
        /bin/cp -rf $src/busybox.exe /bin/awk.exe
        chmod 755 /bin/awk.exe
	else
	    echo "Fixing awk.exe"
        /bin/cp -rf /bin/awk /bin/awk.current
        /bin/cp -rf $src/busybox64.exe /bin/awk.exe
        chmod 755 /bin/awk.exe
    fi

    local src="$babun_source/babun-dist"
    local babun_root
    babun_root=/cygdrive/$( cygpath -ma "/" | sed "s/://"g )/..

    # copy dist files to the dist folder
    cp -rf "$src/fonts" "$babun_root"
    cp -rf "$src/tools" "$babun_root"

    # create dist/ directory required by update script
    mkdir -p "$babun_root/dist"

    # copy scripts
    cp -rf "$src/start/update.bat" "$babun_root"
    cp -rf "$src/start/rebase.bat" "$babun_root"
    cp -rf "$src/start/uninstall.bat" "$babun_root"
}

run
