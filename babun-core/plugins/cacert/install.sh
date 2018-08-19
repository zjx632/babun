#!/bin/bash
set -e -f -o pipefail
source "/usr/local/etc/babun.instance"
# shellcheck source=/usr/local/etc/babun/source/babun-core/tools/script.sh
source "$babun_tools/script.sh"

run() {
    # reference http://stackoverflow.com/a/4454754
    #pushd /usr/ssl/certs 2>/dev/null
    #curl https://curl.haxx.se/ca/cacert.pem | awk '{print > "cert" (1+n) ".pem"} /-----END CERTIFICATE-----/ {n++}'
    #c_rehash
    #popd 2>/dev/null
}

run
