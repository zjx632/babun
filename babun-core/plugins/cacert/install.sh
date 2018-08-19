#!/bin/bash
set -e -f -o pipefail
source "/usr/local/etc/babun.instance"
# shellcheck source=/usr/local/etc/babun/source/babun-core/tools/script.sh
source "$babun_tools/script.sh"

run() {
    # reference http://stackoverflow.com/a/4454754
    pushd /usr/ssl/certs 2>/dev/null
    wget -O - http://curl.haxx.se/ca/cacert.pem | awk 'split_after==1{n++;split_a fter=0} /-----END CERTIFICATE-----/ {split_after=1} {/bin/echo > "cert" n ".pem"}'
    c_rehash
    popd 2>/dev/null
}

run
