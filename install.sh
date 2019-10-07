#!/bin/sh
INSTALL_DIR="$HOME/Work/dotfiles"

if [ -d "$INSTALL_DIR" ]; then
    echo "Updating dotfiles..."
    # idk the reason, but on macos-latest actions file, $INSTALL_DIR always exists and is not a git repository
    if ! git -C "$INSTALL_DIR" pull
    then
        echo "Removing unnecessary directory and renewing dotfiles directory..."
        cd "$HOME/Work" || exit
        rm -rf "$INSTALL_DIR"
        git clone https://github.com/mie998/dotfiles "$INSTALL_DIR"
    fi
else
    echo "Installing dotfiles..."
    git clone https://github.com/mie998/dotfiles "$INSTALL_DIR"
fi

/bin/bash "$INSTALL_DIR/scripts/setup.bash"
