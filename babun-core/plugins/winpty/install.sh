#!/bin/bash
set -e -f -o pipefail
source "/usr/local/etc/babun.instance"
# shellcheck source=/usr/local/etc/babun/source/babun-core/tools/script.sh
source "$babun_tools/script.sh"

if [[ "$DISABLE_PLUGIN_WINPTY" == "true" ]]; then
    return 0
fi


install() {

    local arch=${PROCESSOR_ARCHITECTURE/AMD64/x86_64}
    local archive=/tmp/winpty.tar.gz
    local repo=https://github.com/rprichard/winpty/releases/download

    # TODO(kenjones): Need a lookup mechanism to determine what the latest version is.
    # Because the cygwin version is included in the name it makes it nearly impossible to
    # determine the name of the archive to download.
    if [ "$arch" = "x86" ]; then
        wget -O "$archive" "$repo/0.4.2/winpty-0.4.2-cygwin-2.6.1-ia32.tar.gz"
    else
        wget -O "$archive" "$repo/0.4.2/winpty-0.4.2-cygwin-2.6.1-x64.tar.gz"
    fi

    # install into the /usr/local space
    tar -C /usr/local --strip-components=1 -xv -f "$archive"
    # cleanup by removing the archive file
    rm -f "$archive"

    # make sure it is there and being found as part of the path
    which winpty
}


install
