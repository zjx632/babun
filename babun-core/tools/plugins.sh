#!/bin/bash
set -e -f -o pipefail
source "/usr/local/etc/babun.instance"
# shellcheck source=/usr/local/etc/babun/source/babun-core/tools/script.sh
source "$babun_tools/script.sh"

function plugin_should_install {
    local plugin_name="$1"
    local plugin_version="$2"
    local __resultvar=$3
    local installed="$babun/installed/$plugin_name"
    if [[ -f "$installed" ]]; then
        typeset -i installed_version
        local installed_version
        installed_version=$(cat "$installed" || echo "0")

        if ! [[ $plugin_version -gt $installed_version ]]; then
            echo "  installed [$installed_version]"
            echo "  newest    [$plugin_version]"
            echo "  action    [skip]"
            eval "$__resultvar=0"
            return 0
        fi
    fi
    eval "$__resultvar=1"
}

function plugin_installed_ok {
    local plugin_name="$1"
    local plugin_version="$2"
    local installed="$babun/installed/$plugin_name"
    if [[ -f "$installed" ]]; then
        typeset -i installed_version
        local installed_version
        installed_version=$(cat "$installed" || echo "0")
    fi

    if [[ -z "$installed_version" ]]; then
        local installed_version="none"
    fi

    echo "$plugin_version" > "$installed"
    echo "  installed [$installed_version]"
    echo "  newest    [$plugin_version]"
    echo "  action    [execute]"
}

function plugin_install {
    local plugin_name="$1"
    echo "Installing plugin [$plugin_name]"
    local plugin_desc="$babun/source/babun-core/plugins/$plugin_name/plugin.desc"
    if [[ ! -f "$plugin_desc" ]]; then
        echo "ERROR: Cannot find plugin descriptor [$plugin_name] [$plugin_desc]"
        exit 1
    fi

    local plugin_version
    plugin_version=$(awk -F '=' '/plugin_version/ { printf $2}' "$plugin_desc")

    # checks the version, install only if the version is newer
    # uses the plugin descriptor variables
    plugin_should_install "$plugin_name" "$plugin_version" result
    # shellcheck disable=SC2154
    if [[ "$result" -eq "0" ]]; then
        return 0
    fi

    # execute plugin's install.sh in a separate shell
    local install_script="$babun/source/babun-core/plugins/$plugin_name/install.sh"
    if [[ ! -f "$install_script" ]]; then
        echo "ERROR: Cannot find plugin install.sh script [$plugin_name] [$install_script]"
        exit 1
    fi
    bash "$install_script"

    # sets the version to the newest one
    # uses the plugin descriptor variables
    plugin_installed_ok "$plugin_name" "$plugin_version"
}

function plugin_install_home {
    local plugin_name="$1"
    echo "Installing plugin's home [$plugin_name]"

    # execute plugin's install_home.sh in a separate shell
    local install_home_script="$babun/source/babun-core/plugins/$plugin_name/install_home.sh"
    if [[ ! -f "$install_home_script" ]]; then
        echo "ERROR: Cannot find plugin install_home.sh script [$plugin_name] [$install_home_script]"
        exit 1
    fi
    bash "$install_home_script"
}

function plugin_start {
    local plugin_name="$1"

    local start_script="$babun_plugins/$plugin_name/start.sh"
    if [[ ! -f "$start_script" ]]; then
        echo "ERROR: Cannot find plugin start.sh script [$plugin_name] [$start_script]"
        exit 1
    fi

    bash "$start_script" || echo "Could not start plugin [$plugin_name]"
}

function plugin_uninstall {
    local plugin_name="$1"

    local uninstall_script="$babun_plugins/$plugin_name/uninstall.sh"
    if [[ ! -f "$uninstall_script" ]]; then
        echo "ERROR: Cannot find plugin uninstall.sh script [$plugin_name] [$uninstall_script]"
        exit 1
    fi

    if ! bash "$uninstall_script"; then
        echo "Could not uninstall plugin [$plugin_name]"
        return 0
    fi

    rm -f "$babun/installed/$plugin_name"
    echo "$plugin_name successfully uninstalled"
}
