#!/bin/sh
INSTALL_DIR="$HOME/Work/dotfiles"

# if [ -d "$INSTALL_DIR" ]; then
#     echo "Updating dotfiles..."
#     git -C "$INSTALL_DIR" pull
# else
#     echo "Installing dotfiles..."
#     git clone https://github.com/mie998/dotfiles "$INSTALL_DIR"
# fi
echo "Installing dotfiles..."
git clone https://github.com/mie998/dotfiles "$INSTALL_DIR"

/bin/bash "$INSTALL_DIR/scripts/setup.bash"
