#!/usr/bin/env bash

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

#NOTICE: use of nvim on AstraNvim requires NerdFont. install font from here (option6 is recommended) https://github.com/ryanoasis/nerd-fonts
#NOTICE: if you are using wsl2, install font on windows side and setting from right clicking wsl2 panel.
