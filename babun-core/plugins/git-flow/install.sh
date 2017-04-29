#!/bin/bash
set -e -f -o pipefail
source "/usr/local/etc/babun.instance"
# shellcheck source=/usr/local/etc/babun/source/babun-core/tools/script.sh
source "$babun_tools/script.sh"

if [ -z "$GIT_FLOW_BRANCH" ]; then
  GIT_FLOW_BRANCH="stable"
fi


run() {
    # Reference: https://github.com/petervanderdoes/gitflow-avh/wiki/Installing-on-Windows#cygwin
    local url=https://raw.githubusercontent.com/petervanderdoes/gitflow/develop/contrib/gitflow-installer.sh
    local script=gitflow-installer.sh

    pushd /tmp 2>/dev/null

    wget -O "$script" "$url"
    bash "$script" install "$GIT_FLOW_BRANCH"

    rm -f "$script"
    rm -rf gitflow
    popd 2>/dev/null
}

run
