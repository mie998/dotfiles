#!/usr/bin/env bash

# NOTICE: nvim will be installed via https://crates.io/crates/bob-nvim
# NOTICE: with ubuntu apt package manager, only old version is able to installed.
# NOTICE: please watch to call this script after cargo-setup.bash
export BOB_HOME="$XDG_DATA_HOME/bob"

set -x
# shellcheck source=./scripts/common.bash
source "$(dirname "$0")/common.bash"

export NVIM_PATH="$BOB_HOME/nvim-bin"

if [ -d "$NVIM_PATH/nvim" ]; then
    echo "neovim is already installed via cargo-bob."
else
    echo "start install neovim via cargo-bob"
    bob install stable
    bob use stable
fi
