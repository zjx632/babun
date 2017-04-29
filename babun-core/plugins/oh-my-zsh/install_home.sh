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

    typeset -i installed_version
    installed_version=$(cat "$babun/installed/oh-my-zsh" || echo "0")

    local src="$babun/home/oh-my-zsh"

    if [ ! -d "$homedir/.oh-my-zsh" ]; then
        git --git-dir="$src/.oh-my-zsh/.git" --work-tree="$src/.oh-my-zsh" reset --hard
        # installing oh-my-zsh
        chmod 755 -R "$src/.oh-my-zsh"
        cp -rf "$src/.oh-my-zsh" "$homedir/.oh-my-zsh"

        # setting zsh as the default shell
        if grep -q "/bin/bash" "/etc/passwd"; then
            sed -i 's/\/bin\/bash/\/bin\/zsh/' "/etc/passwd"
        fi
    fi

    if [ ! -f "$homedir/.zshrc" ]; then
        cp "$babun/home/.zshrc" "$homedir/.zshrc"

        # fixing oh-my-zsh components
        zsh -c "source ~/.zshrc; rm -f \"$homedir/.zcompdump\"; compinit -u" &> /dev/null
        zsh -c "source ~/.zshrc; cat \"$homedir/.zcompdump\" > \"$homedir/.zcompdump-\"*" &> /dev/null
    fi

    if [[ "$installed_version" -le 1 ]]; then
        git --git-dir="$homedir/.oh-my-zsh/.git" --work-tree="$homedir/.oh-my-zsh" config core.trustctime false
        git --git-dir="$homedir/.oh-my-zsh/.git" --work-tree="$homedir/.oh-my-zsh" config core.autocrlf false
        git --git-dir="$homedir/.oh-my-zsh/.git" --work-tree="$homedir/.oh-my-zsh" rm --cached -r . > /dev/null
        git --git-dir="$homedir/.oh-my-zsh/.git" --work-tree="$homedir/.oh-my-zsh" reset --hard
    fi
}

run
