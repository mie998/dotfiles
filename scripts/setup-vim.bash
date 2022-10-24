#!/usr/bin/env bash
set -x
# shellcheck source=./scripts/common.bash
source "$(dirname "$0")/common.bash"

if [ -d "$XDG_DATA_HOME/.vim/colors/molokai" ]; then
    echo "vim molokai theme is already installed."
else
    mkdir -p "$XDG_DATA_HOME/.vim/colors/molokai"
    echo "Installing vim molokai theme..."
    git clone https://github.com/tomasr/molokai "$XDG_DATA_HOME/.vim/colors/molokai"
fi
