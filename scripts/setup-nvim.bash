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

# install AstroNvim and setting its user config
mkdir -p "$XDG_CONFIG_HOME/nvim"
if [ ! -d "$XDG_CONFIG_HOME/nvim/AstroNvim" ]; then
    git clone --depth 1 https://github.com/AstroNvim/AstroNvim "$XDG_CONFIG_HOME/nvim"
fi
if [ ! -d "$XDG_CONFIG_HOME/nvim/lua/user" ]; then
    git submodule update --init --recursive
    ln -sfnv "$REPO_DIR/config/nvim/lua/user" "$XDG_CONFIG_HOME/nvim/lua/user"
fi
