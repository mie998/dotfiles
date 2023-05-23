#!/usr/bin/env bash
set -x
# shellcheck source=./scripts/common.bash
source "$(dirname "$0")/common.bash"

# Install molokai theme for vim
if [ -d "$XDG_DATA_HOME/.vim/colors/molokai" ]; then
    echo "vim molokai theme is already installed."
else
    mkdir -p "$XDG_DATA_HOME/.vim/colors/molokai"
    echo "Installing vim molokai theme..."
    git clone https://github.com/tomasr/molokai "$XDG_DATA_HOME/.vim/colors/molokai"
fi

# setting up vim-plug
# cf. https://github.com/junegunn/vim-plug/wiki/tutorial
# for vim
export VIM_PLUG_PATH="$XDG_DATA_HOME/.vim/autoload/plug.vim"
if [ -f "$VIM_PLUG_PATH" ]; then
    echo "vim-plug for vim is already installed."
else
    echo "Installing vim-plug..."
    curl -fLo "$VIM_PLUG_PATH" --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
fi

# for neovim use just a symlink
if [ -f "$XDG_DATA_HOME/.local/share/nvim/site/autoload/plug.vim" ]; then
    echo "vim-plug for neovim is already installed."
else
    echo "create a symlink of vim-plug for neovim..."
    ln -s "$VIM_PLUG_PATH" "$XDG_DATA_HOME/.local/share/nvim/site/autoload/plug.vim"
fi
