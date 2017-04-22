#!/bin/bash
set -e -f -o pipefail
source "/usr/local/etc/babun.instance"
# shellcheck source=/usr/local/etc/babun/source/babun-core/tools/script.sh
source "$babun_tools/script.sh"

if [[ "$DISABLE_PLUGIN_SHELL_HERE" == "true" ]]; then
    return 0
fi

#start with installing chere
pact install chere || echo "Installing 'chere' failed. Please execute 'pact install chere' to fix it otherwise the plugin may not work."

#install registry keys
"$babun_plugins/shell-here/exec.sh" init
