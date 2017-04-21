#!/bin/bash
set -e -f -o pipefail
source "/usr/local/etc/babun.instance"
# shellcheck source=/usr/local/etc/babun/source/babun-core/tools/script.sh
source "$babun_tools/script.sh"
# shellcheck source=/usr/local/etc/babun/source/babun-core/tools/procps.sh
source "$babun_tools/procps.sh"
# shellcheck source=/usr/local/etc/babun/source/babun-core/tools/cygwin.sh
source "$babun_tools/cygwin.sh"

check_file_permissions_on_update

# install/update plugins
"$babun"/source/babun-core/plugins/install.sh || { echo "ERROR: Could not update babun!"; exit -2; }

# install/update home folder
"$babun"/source/babun-core/plugins/install_home.sh || { echo "ERROR: Could not update home folder! Try executing 'babun install' manually!"; exit -3; }

# set the newest version marker
cat "$babun/source/babun.version" > "$babun/installed/babun"

# execute cygwin update
update_cygwin_instance

# login to the default shell once again to execute plugin startup sequence
# shellcheck disable=SC2119
proc_shell_login
