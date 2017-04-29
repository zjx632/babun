#!/bin/bash
set -e -f -o pipefail
source "/usr/local/etc/babun.instance"
# shellcheck source=/usr/local/etc/babun/source/babun-core/tools/script.sh
source "$babun_tools/script.sh"

run() {
    local arch=${PROCESSOR_ARCHITECTURE/AMD64/x86_64}
    local src="$babun_source/babun-core/plugins/cygfix/src"

    if [ "$arch" = "x86" ]; then
        echo "Fixing mkpasswd.exe"
        /bin/cp -rf /bin/mkpasswd.exe /bin/mkpasswd.exe.current
        /bin/cp -rf $src/bin/mkpasswd_1.7.29.exe /bin/mkpasswd.exe
        chmod 755 /bin/mkpasswd.exe

        echo "Fixing mkgroup.exe"
        /bin/cp -rf /bin/mkgroup.exe /bin/mkgroup.exe.current
        /bin/cp -rf $src/bin/mkgroup_1.7.29.exe /bin/mkgroup.exe
        chmod 755 /bin/mkgroup.exe
    fi

    if [ ! -f "/bin/vi" ]
    then
        ln -s /usr/bin/vim /bin/vi
    fi
}

run
