#!/bin/bash
set -e -f -o pipefail
source "/usr/local/etc/babun.instance"
# shellcheck source=/usr/local/etc/babun/source/babun-core/tools/script.sh
source "$babun_tools/script.sh"

init() {
    local babun_root
    babun_root="$( cygpath -w "/" | sed "s#\\\cygwin##g" )"
    # the name that appears in the right-click context menu
    local name="Open Babun here"
    local cmd="${babun_root}\cygwin\bin\mintty.exe /bin/env CHERE_INVOKING=1 $SHELL.exe"

    local keys=("HKCU\Software\Classes\Directory\Background\shell\babun"
    "HKCU\Software\Classes\Directory\shell\babun"
    "HKCU\Software\Classes\Drive\Background\Shell\babun"
    "HKCU\Software\Classes\Drive\shell\babun")

    # install registry keys
    for key in ${keys[*]}
    do
        cmd /c "reg" "add" "${key}" "/ve" "/d" "${name}" "/t" "REG_SZ" "/f" || echo "Failed adding ${key}"
        cmd /c "reg" "add" "${key}\command" "/ve" "/d" "${cmd}" "/t" "REG_EXPAND_SZ" "/f" || echo "Failed adding ${key}"
    done
}

run() {
    if [[ "$DISABLE_PLUGIN_SHELL_HERE" == "true" ]]; then
        return 0
    fi

    # start with installing chere
    pact install chere || echo "Installing 'chere' failed. Please execute 'pact install chere' to fix it otherwise the plugin may not work."

    # install registry keys
    init
}

run
