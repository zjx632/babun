#!/bin/bash
set -e -f -o pipefail
source "/usr/local/etc/babun.instance"
# shellcheck source=/usr/local/etc/babun/source/babun-core/tools/script.sh
source "$babun_tools/script.sh"


install() {
    # install completion for git-flow
    local base=https://raw.githubusercontent.com/petervanderdoes/git-flow-completion/develop

    if [ "$SHELL" = "/bin/bash" ]; then
        wget -O /etc/bash_completion.d/git-flow "$base/git-flow-completion.bash"
    else
        mkdir -p "$ZSH/completions"
        wget -O "$ZSH/completions/git-flow-completion.zsh" "$base/git-flow-completion.zsh"
    fi

}

install
