#!/bin/bash

mkdir -p /usr/local/etc/babun/source
cp -R /mnt/* /usr/local/etc/babun/source/

mapfile -t SCRIPTS < <(find . -name "*.sh")
LIBS=("/usr/local/etc/babun.instance")

# shellcheck disable=SC2086
shellcheck -s 'bash' -x "${LIBS[*]}" ${SCRIPTS[*]}

declare -a MISC
MISC=("babun-core/plugins/pact/src/pact" "babun-core/plugins/core/src/babun" "babun-core/plugins/core/src/babun.rc")
# shellcheck disable=SC2086
shellcheck -s 'bash' -x "${LIBS[*]}" ${MISC[*]}
