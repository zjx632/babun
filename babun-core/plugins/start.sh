#!/bin/bash
set -e -f -o pipefail
source "/usr/local/etc/babun.instance"
# shellcheck source=/usr/local/etc/babun/source/babun-core/tools/script.sh
source "$babun_tools/script.sh"
# shellcheck source=/usr/local/etc/babun/source/babun-core/tools/plugins.sh
source "$babun_tools/plugins.sh"


# start plugins
plugin_start "git"
plugin_start "core"
plugin_start "cygdrive"
plugin_start "cygfix"
