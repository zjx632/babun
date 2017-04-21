#!/bin/bash
set -e -f -o pipefail
source "/usr/local/etc/babun.instance"
# shellcheck source=/usr/local/etc/babun/source/babun-core/tools/script.sh
source "$babun_tools/script.sh"

mapfile -t rdirs < <(find / -maxdepth 1 -type l)
for root_dir in "${rdirs[@]}"
do
    link_target=$(readlink "$root_dir")

    if [[ "$link_target" =~ ^/cygdrive/.$ ]]; then
        rm "$root_dir" || true
    fi
done

if ! [[ "$DISABLE_PLUGIN_CYGDRIVE" == "true" ]]; then

    mapfile -t cdirs < <(find /cygdrive/ -maxdepth 1 -type d 2>/dev/null)
    for cygdrive_dir in "${cdirs[@]}"
    do
        drive_name=$(basename "$cygdrive_dir")

        if [[ "$drive_name" != "cygdrive" ]]; then
            ln -s "$cygdrive_dir" "/$drive_name"
        fi
    done

fi
