#!/bin/sh -e
ubuntu_version="$(lsb_release -r | awk '{print $2 * 100}')"

add-apt-repository -y \
    ppa:git-core/ppa \
    universe
apt-get update
apt-get upgrade -y
apt-get install -y \
    autoconf \
    build-essential \
    clang \
    clangd \
    clang-format \
    cmake \
    direnv \
    fzf \
    git \
    git-lfs \
    gpg \
    jq \
    libsqlite3-dev \
    libssl-dev \
    python3 \
    python3-pip \
    shellcheck \
    sqlite3 \
    tmux \
    unzip \
    wget \
    zip \
    zsh

curl -fsSL 'https://download.docker.com/linux/ubuntu/gpg' | apt-key add -
add-apt-repository -y "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
apt-get update
apt-get install -y docker-ce docker-ce-cli
