#!/bin/bash
set -e -f -o pipefail
source "/usr/local/etc/babun.instance"
# shellcheck source=/usr/local/etc/babun/source/babun-core/tools/script.sh
source "$babun_tools/script.sh"

run() {

    if [ -f /bin/mkpasswd.exe.current ]; then
        mv /bin/mkpasswd.exe.current /bin/mkpasswd.exe
    fi

    if [ -f /bin/mkgroup.exe.current ]; then
        mv /bin/mkgroup.exe.current /bin/mkgroup.exe
    fi
}

run
