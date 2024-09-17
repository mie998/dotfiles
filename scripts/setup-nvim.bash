#!/usr/bin/env bash

if command -v nvim &> /dev/null
then
    echo "nvim already installed!!"
    exit 0
fi

set -x
# shellcheck source=./scripts/common.bash
source "$(dirname "$0")/common.bash"

if [ "$(uname)" == "Darwin" ]; then
    # maybe duplicated with setup-mac.bash
    brew install neovim
elif [ "$(printf '%s' "$(uname -s)" | cut -c 1-5)" == "Linux" ]; then
    curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim.appimage
    chmod u+x nvim.appimage
    sudo mv nvim.appimage /usr/local/bin/nvim
fi
