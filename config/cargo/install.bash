#!/usr/bin/env bash
set -eux

# restart shell in case cargo is not in the $PATH
exec $SHELL -l

cargo install \
    cargo-binstall

cargo binstall -y \
    bat \
    cargo-update \
    eza \
    fd-find \
    git-delta \
    gitui \
    grex \
    hexyl \
    hyperfine \
    lsd \
    ripgrep \
    sd \
    starship \
    sheldon \
    tealdeer \
    tokei \
    xh \
    zoxide
