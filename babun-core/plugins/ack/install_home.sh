#!/bin/bash
set -e -f -o pipefail
source "/usr/local/etc/babun.instance"
# shellcheck source=/usr/local/etc/babun/source/babun-core/tools/script.sh
source "$babun_tools/script.sh"


run() {
    if [[ "$DISABLE_PLUGIN_ACK" == "true" ]]; then
        echo "ack plugin is currently disabled; check ~/.babunrc to enable"
        return 0
    fi

    local source=https://github.com/mileszs/ack.vim/archive/1.0.9.tar.gz
    local archive=/tmp/ack-vim.tar.gz

    wget -O "$archive" "$source"

    tar -C "$homedir/.vim" \
        --strip-components=1 \
        --exclude=autoload \
        --exclude=ftplugin \
        --exclude=.* \
        --exclude=LICENSE \
        --exclude=README.md \
        -xf "$archive"

    rm -f "$archive"
}

run
