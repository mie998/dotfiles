#!/bin/sh
INSTALL_DIR="${INSTALL_DIR:-$HOME/Work/dotfiles}"

if [ -d "$INSTALL_DIR" ]; then
    echo "Updating dotfiles..."

    cd "$INSTALL_DIR"
    pwd
    ls -a
    git status

    git -C "$INSTALL_DIR" pull
else
    echo "Installing dotfiles..."
    git clone https://github.com/mie998/dotfiles "$INSTALL_DIR"
fi

/bin/bash "$INSTALL_DIR/scripts/setup.bash"
