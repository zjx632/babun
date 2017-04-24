#!/bin/bash

# FIX_RELEASE
# set (the following commands do not work at all)
# -f (does not work with oh-my-zsh)
# -e (does not work )
# -o pipefail (no pipe fail as there is not pipe in this 'cking script :))
source "/usr/local/etc/babun.instance"
# shellcheck source=/usr/local/etc/babun/source/babun-core/tools/script.sh
source "$babun_tools/script.sh"
# shellcheck source=/usr/local/etc/babun/source/babun-core/tools/stamps.sh
source "$babun_tools/stamps.sh"

function get_current_version {
    dos2unix $babun/installed/babun 2> /dev/null
    local current_version
    current_version=$( cat "$babun/installed/babun" 2> /dev/null || echo "0.0.0" )
    echo "$current_version"
}

function get_current_source_version {
    local current_source_version
    current_source_version=$( cat "$babun_source/babun.version" 2> /dev/null || echo "0.0.0" )
    echo "$current_source_version"
}

function get_newest_version {
    if [[ -z $CHECK_TIMEOUT_IN_SECS ]]; then
        CHECK_TIMEOUT_IN_SECS=4
    fi
    local url
    url=$( git --git-dir=$babun_source/.git config --get remote.origin.url | sed -e 's/\.git//' )/raw/$BABUN_BRANCH/babun.version
    local newest_version
    newest_version=$( curl --silent --insecure --user-agent "$USER_AGENT" --connect-timeout $CHECK_TIMEOUT_IN_SECS --location "$url" || echo "" )
    echo "$newest_version"
}

function get_current_cygwin_version {
    local current_cygwin_version
    current_cygwin_version=$( uname -r | sed -e 's/(.*//' 2> /dev/null || echo "0.0.0" )
    echo "$current_cygwin_version"
}

function get_newest_cygwin_version_from_cygwin {
    if [[ -z $CHECK_TIMEOUT_IN_SECS ]]; then
        CHECK_TIMEOUT_IN_SECS=4
    fi

    if [[ -z $(which tidy 2> /dev/null) ]]; then
        echo ""
        return
    fi

    local html=/tmp/cygwin.html

    # download the front page from cygwin.com
    curl --silent --insecure --user-agent "$USER_AGENT" --connect-timeout $CHECK_TIMEOUT_IN_SECS --location -o "$html" https://cygwin.com
    # format the page such that the string being searched are on the same line
    tidy -f /dev/null -q -m -w 180 "$html"
    local ver
    ver=$(grep "most recent version of the Cygwin DLL" "$html" | grep -E -o "([0-9]{1,}\.)+[0-9]{1,}")
    rm -f "$html"
    echo "$ver"
}

function get_newest_cygwin_version {
    local ver
    ver=$( get_newest_cygwin_version_from_cygwin )
    if [[ ! -z "$ver" ]]; then
        echo "$ver"
        return
    fi

    if [[ -z $CHECK_TIMEOUT_IN_SECS ]]; then
        CHECK_TIMEOUT_IN_SECS=4
    fi
    local url
    url=$( git --git-dir=$babun_source/.git config --get remote.origin.url | sed -e 's/\.git//' )/raw/$BABUN_BRANCH/cygwin.version
    local newest_cygwin_version
    newest_cygwin_version=$( curl --silent --insecure --user-agent "$USER_AGENT" --connect-timeout $CHECK_TIMEOUT_IN_SECS --location "$url" || echo "" )
    echo "$newest_cygwin_version"
}

function get_version_as_number {
    version_string=$1
    # first digit
    major=$(( ${version_string%%.*}*100000 ))
    # second digit (almost)
    minor_tmp=${version_string%.*}
    minor=$(( ${minor_tmp#*.}*1000 ))
    # third digit
    revision=$(( ${version_string##*.} ))
    version_number=$(( major + minor + revision ))
    echo "$version_number"
}

function exec_check_unfinished_update {
    local installed_version
    installed_version=$( get_version_as_number get_current_version )
    local source_version
    source_version=$( get_version_as_number get_current_source_version )
    if ! [[ $installed_version -eq $source_version ]]; then
        echo "Source consistent [FAILED]"
        echo "Hint: babun is in INCONSISTENT state! Run babun update to finish the update process!"
    else
        echo "Source consistent [OK]"
    fi
}

function exec_check_prompt {
    # check git prompt speed
    ts=$(date +%s%N) ;
    git --git-dir="$babun/source/.git" --work-tree="$babun/source" branch > /dev/null 2>&1 ;
    time_taken=$((($(date +%s%N) - ts)/1000000)) ;
    if [[ $time_taken -gt 200 ]]; then
        # evaluate once more
        time_taken=$((($(date +%s%N) - ts)/1000000)) ;
    fi

    if [[ $time_taken -lt 500 ]]; then
        echo "Prompt speed      [OK]"
    else
        echo "Prompt speed      [SLOW]"
        echo "Hint: your prompt is very slow. Check the installed 'BLODA' software."
    fi
}

function exec_check_permissions {
    permcheck=$( chmod 777 /etc/passwd /usr/local/bin/babun 2> /dev/null || echo "FAILED" )
    if [[  $permcheck == "FAILED" ]]; then
        echo "File permissions  [FAILED]"
        echo "Hint: Have you installed babun as admin and run it from a non-admin account?"
    else
        echo "File permissions  [OK]"
    fi
}

function exec_check_cygwin {
    local newest_cygwin_version
    newest_cygwin_version=$( get_newest_cygwin_version )
    if [[ -z "$newest_cygwin_version" ]]; then
        echo "Cygwin check      [FAILED]"
        return
    else

        local newest_cygwin_version_number
        newest_cygwin_version_number=$( get_version_as_number "$newest_cygwin_version" )
        local current_cygwin_version
        current_cygwin_version=$( get_current_cygwin_version )
        local current_cygwin_version_number
        current_cygwin_version_number=$( get_version_as_number "$current_cygwin_version" )
        if [[ $newest_cygwin_version_number -gt $current_cygwin_version_number ]]; then
            echo "Cygwin check      [OUTDATED]"
            echo "Hint: the underlying Cygwin kernel is outdated. Execute 'babun update'"
        else
            echo "Cygwin check      [OK]"
        fi
    fi
}

function babun_check {
    exec_check_unfinished_update
    exec_check_prompt
    exec_check_permissions

    local newest_version
    newest_version=$( get_newest_version )
    if [[ -z "$newest_version" ]]; then
        echo "Connection check  [FAILED]"
        echo "Update check      [FAILED]"
        echo "Hint: adjust proxy settings in ~/.babunrc and execute 'source ~/.babunrc'"
        return
    else
        echo "Connection check  [OK]"
    fi

    local current_version
    current_version=$( get_current_version )
    local current_version_number
    current_version_number=$( get_version_as_number "$current_version" )
    local newest_version_number
    newest_version_number=$( get_version_as_number "$newest_version" )
    if [[ $newest_version_number -gt $current_version_number ]]; then
        echo "Update check      [OUTDATED]"
        echo "Hint: your babun is outdated. Execute 'babun update'"
    else
        echo "Update check      [OK]"
    fi

    exec_check_cygwin
}


function guarded_babun_check {
    local check_stamp="$babun/stamps/check"
    if ! [ "$(find "$babun/stamps" -mtime 0 -type f -name 'check' 2>/dev/null || true )" ]; then
        echo "Executing daily babun check:"
        babun_check
        date > "$check_stamp"
    fi
}
