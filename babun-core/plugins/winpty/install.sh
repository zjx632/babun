#!/bin/bash
set -e -f -o pipefail
source "/usr/local/etc/babun.instance"
# shellcheck source=/usr/local/etc/babun/source/babun-core/tools/script.sh
source "$babun_tools/script.sh"


run() {
    local arch=${PROCESSOR_ARCHITECTURE/AMD64/x86_64}
    local archive=/tmp/winpty.tar.gz
    local repo=https://github.com/rprichard/winpty/releases/download
    local state_dir="$babun/external/winpty"
    local install_dir=/usr/local

    # TODO(kenjones): Need a lookup mechanism to determine what the latest version is.
    # Because the cygwin version is included in the name it makes it nearly impossible to
    # determine the name of the archive to download.
    if [ "$arch" = "x86" ]; then
        wget -O "$archive" "$repo/0.4.2/winpty-0.4.2-cygwin-2.6.1-ia32.tar.gz"
    else
        wget -O "$archive" "$repo/0.4.2/winpty-0.4.2-cygwin-2.6.1-x64.tar.gz"
    fi

    mkdir -p "$state_dir"
    rm -f "$state_dir/installed"
    mapfile -t parts < <(tar -tf "$archive" | sed 's,^[^/]*/,,')
    for p in "${parts[@]}"; do
        [[ -z "$p" ]] && continue
        case "$p" in
            */) continue ;;
            # only keep the paths to files and not directories
            *)  echo "$install_dir/$p" >> "$state_dir/installed" ;;
        esac
    done

    # install into the install directory
    tar -C "$install_dir" --strip-components=1 -xf "$archive"
    # cleanup by removing the archive file
    rm -f "$archive"

    echo "# installed files:"
    cat "$state_dir/installed"

    # make sure it is there and being found as part of the path
    echo "# exectuable:"
    which winpty
}

run
