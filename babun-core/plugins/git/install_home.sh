#!/bin/bash
set -e -f -o pipefail
source "/usr/local/etc/babun.instance"
# shellcheck source=/usr/local/etc/babun/source/babun-core/tools/script.sh
source "$babun_tools/script.sh"


apply_git_config() {
    declare -A configMap="${1#*=}"

    gitcfg=$(git config --list)

    for configKey in "${!configMap[@]}"
    do
        if [[ $gitcfg != *$configKey* ]]; then
            configValue="${configMap[$configKey]}"
            git config --global "$configKey" "$configValue"
        fi
    done
}

apply_fixes() {
    # COMPATIBILITY FIX
    # BUG FIX -> alias.last
    gitlast=$(git config --global alias.last || echo "")
    if [[ "$gitlast" == "git log -1 --stat" ]]; then
        echo "Fixing broken alias.last"
        git config --global "alias.last" "log -1 --stat"
    fi
}

install_completion() {
    # install completion for git
    src=https://raw.githubusercontent.com/git/git/master/contrib/completion
    wget -O /etc/bash_completion.d/git "$src/git-completion.bash"

    if [ "$SHELL" = "/bin/zsh" ]; then
        mkdir -p "$ZSH/completions"
        wget -O "$ZSH/completions/_git" "$src/git-completion.zsh"
    fi
}

run() {
    declare -A gitconfig
    declare -A gitalias
    declare -A gitmerge

    # general config
    gitconfig['color.ui']='true'
    gitconfig['core.editor']='vim'
    gitconfig['core.filemode']='false'
    gitconfig['credential.helper']='cache --timeout=3600'
    gitconfig['push.default']='matching'

    # alias config
    gitalias['alias.cp']='cherry-pick'
    gitalias['alias.st']='status -sb'
    gitalias['alias.cl']='clone'
    gitalias['alias.ci']='commit'
    gitalias['alias.co']='checkout'
    gitalias['alias.br']='branch'
    gitalias['alias.dc']='diff --cached'
    gitalias['alias.lg']="log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %Cblue<%an>%Creset' --abbrev-commit --date=relative --all"
    gitalias['alias.last']='log -1 --stat'
    gitalias['alias.unstage']='reset HEAD --'
    gitalias['alias.boom']='reset --hard HEAD'

    # git mergetool config
    gitmerge['merge.tool']='vimdiff'
    gitmerge['mergetool.prompt']='false'
    gitmerge['mergetool.trustexitcode']='false'
    gitmerge['mergetool.keepbackups']='false'
    gitmerge['mergetool.keeptemporaries']='false'

    # install pre-defined configurations
    apply_git_config "$(declare -p gitconfig)"
    apply_git_config "$(declare -p gitmerge)"
    apply_git_config "$(declare -p gitalias)"

    # repair invalid/broken configurations
    apply_fixes

    # install git completion
    install_completion
}

run
