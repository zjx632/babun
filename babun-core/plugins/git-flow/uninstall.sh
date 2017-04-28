#!/bin/bash
set -e -f -o pipefail
source "/usr/local/etc/babun.instance"
# shellcheck source=/usr/local/etc/babun/source/babun-core/tools/script.sh
source "$babun_tools/script.sh"


uninstall() {
    # Reference: https://github.com/petervanderdoes/gitflow-avh/wiki/Installing-on-Windows#cygwin
    local url=https://raw.githubusercontent.com/petervanderdoes/gitflow/develop/contrib/gitflow-installer.sh
    local script=gitflow-installer.sh

    pushd /tmp 2>/dev/null

    wget -O "$script" "$url"
    bash "$script" uninstall

    rm -f "$script"
    popd 2>/dev/null
}

uninstall
