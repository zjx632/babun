#!/bin/bash
set -e -f -o pipefail
source "/usr/local/etc/babun.instance"
# shellcheck source=/usr/local/etc/babun/source/babun-core/tools/script.sh
source "$babun_tools/script.sh"


remove() {
    local keys=("HKCU\Software\Classes\Directory\Background\shell\babun"
    "HKCU\Software\Classes\Directory\shell\babun"
    "HKCU\Software\Classes\Drive\Background\Shell\babun"
    "HKCU\Software\Classes\Drive\shell\babun")

    # uninstall registry keys
    for key in ${keys[*]}
    do
        cmd /c "reg" "delete" "${key}" "/f" || echo "Failed deleting ${key}"
    done
}

run() {
    if [[ "$DISABLE_PLUGIN_SHELL_HERE" == "true" ]]; then
        return 0
    fi

    # uninstall registry keys
    remove
}

run
