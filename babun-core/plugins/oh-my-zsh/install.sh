#!/bin/bash
set -e -f -o pipefail
source "/usr/local/etc/babun.instance"
# shellcheck source=/usr/local/etc/babun/source/babun-core/tools/script.sh
source "$babun_tools/script.sh"


run() {
    if [[ "$DISABLE_PLUGIN_OH_MY_ZSH" == "true" ]]; then
        echo "oh-my-zsh plugin is currently disabled; check ~/.babunrc to enable"
        return 0
    fi

    # shellcheck source=/usr/local/etc/babun/source/babun-core/tools/git.sh
    source "$babun_tools/git.sh"

    local src="$babun/external/oh-my-zsh"
    local dest="$babun/home/oh-my-zsh/.oh-my-zsh"

    if [ ! -d "$src" ]; then
        git clone https://github.com/robbyrussell/oh-my-zsh.git "$src"
        git --git-dir="$src/.git" --work-tree="$src" config core.trustctime false
        git --git-dir="$src/.git" --work-tree="$src" config core.autocrlf false
        git --git-dir="$src/.git" --work-tree="$src" rm --cached -r . > /dev/null
        git --git-dir="$src/.git" --work-tree="$src" reset --hard
    fi

    if [ ! -d "$dest" ]; then
        mkdir -p "$dest"
        cp -rf "$src/." "$dest"
        cp "$dest/templates/zshrc.zsh-template" "$babun/home/.zshrc"
        sed -i 's/ZSH_THEME=".*"/ZSH_THEME="babun"/' "$babun/home/.zshrc"
        cp -rf "$babun_source/babun-core/plugins/oh-my-zsh/src/babun.zsh-theme" "$dest/custom"
    fi
}

run
