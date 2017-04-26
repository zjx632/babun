#!/bin/bash
set -e -f -o pipefail
source "/usr/local/etc/babun.instance"
# shellcheck source=/usr/local/etc/babun/source/babun-core/tools/script.sh
source "$babun_tools/script.sh"

src="$babun_source/babun-core/plugins/shell/src/"
dest="$babun/home/shell/"

/bin/cp -f /etc/minttyrc /etc/minttyrc.old  || :
/bin/cp -f $src/minttyrc /etc/minttyrc

/bin/cp -f /etc/nanorc /etc/nanorc.old  || :
/bin/cp -f $src/nanorc /etc/nanorc

/bin/cp -f /etc/vimrc /etc/vimrc.old  || :
/bin/cp -f $src/vimrc /etc/vimrc

mkdir -p "$dest"
/bin/cp -rf "$src/.vim" "$dest/.vim"
