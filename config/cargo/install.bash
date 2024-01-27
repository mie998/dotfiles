#!/usr/bin/env bash
set -eux

cargo install \
    cargo-binstall

cargo binstall -y \
    bat \
    cargo-update \
    exa \
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
    tealdeer \
    tokei \
    xh \
    zoxide
