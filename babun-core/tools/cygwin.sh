#!/bin/bash
set -e -f -o pipefail
# shellcheck source=/usr/local/etc/babun/source/babun-core/tools/check.sh
source "$babun_tools/check.sh"

function update_cygwin_instance() {

    local newest_cygwin_version
    newest_cygwin_version=$( get_newest_cygwin_version )
    if [[ -z "$newest_cygwin_version" ]]; then
        echo "ERROR: Cannot fetch the newest Cygwin version from github. Are you behind a proxy? Execute 'babun check' to find out."
        exit -1
    fi

    local newest_cygwin_version_number
    newest_cygwin_version_number=$( get_version_as_number "$newest_cygwin_version" )
    local current_cygwin_version
    current_cygwin_version=$( get_current_cygwin_version )
    local current_cygwin_version_number
    current_cygwin_version_number=$( get_version_as_number "$current_cygwin_version" )
    echo "Checking Cygwin version:"
    echo "  installed [$current_cygwin_version]"
    echo "  newest    [$newest_cygwin_version]"

    if [[ $newest_cygwin_version_number -gt $current_cygwin_version_number ]]; then
        echo "Cygwin is outdated"
        local babun_root
        babun_root=$( cygpath -ma "/" | sed "s#/cygwin##g" )
        local running_count
        # shellcheck disable=SC2009,SC2126
        running_count=$( ps | grep /usr/bin/mintty | wc -l )
        if [[ $running_count -gt 1 ]]; then
            echo "------------------------------------------------------------------"
            echo "ERROR: Cannot upgrade Cygwin! There's $running_count running babun instance[s]."
            echo "Close all OTHER babun windows [mintty] and execute 'babun update'"
            echo "------------------------------------------------------------------"
            return
        fi
        echo "------------------------------------------------------------------"
        echo "Babun will close itself in 5 seconds to upgrade the underlying Cygwin instance."
        echo "DO NOT close the window during the update process!"
        echo "------------------------------------------------------------------"
        sleep 5
        echo "Upgrading Cygwin in:"
        for i in {3..1}
        do
           echo "$i"
           sleep 1
        done
        echo "0"
        cygstart "$babun_root/update.bat" && pkill 'mintty'
    else
        echo "Cygwin is up to date"
    fi

}

function check_file_permissions_on_update() {
    permcheck=$( chmod 777 /etc/passwd /usr/local/bin/babun 2> /dev/null || echo "FAILED" )
    if [[  $permcheck == "FAILED" ]]; then
        echo "-----------------------------------------------------------------"
        echo "ERROR: The update has failed! You don't have write permission to / filesystem!"
        echo "Your babun instance is NOT in a consistent state right now."
        echo "Restart babun as an Admin and rexecute babun update!"
        echo "-----------------------------------------------------------------"
        exit 1
    fi
}
