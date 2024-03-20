#!/usr/bin/env bash
set -eux

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
    mise \
    ripgrep \
    sd \
    starship \
    sheldon \
    tealdeer \
    tokei \
    xh \
    zoxide
