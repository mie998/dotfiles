#!/bin/sh
rustup install stable
rustup default stable

cargo update
cargo install \
    alacritty \
    cargo-binstall

cargo binstall -y \
    bat \
    cargo-compete \
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
