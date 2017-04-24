#!/bin/bash
set -e -f -o pipefail
source "/usr/local/etc/babun.instance"
# shellcheck source=/usr/local/etc/babun/source/babun-core/tools/script.sh
source "$babun_tools/script.sh"

if [[ "$DISABLE_PLUGIN_SHELL_HERE" == "true" ]]; then
    return 0
fi

# uninstall registry keys
"$babun_plugins/shell-here/exec.sh" remove
