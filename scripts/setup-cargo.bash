#!/usr/bin/env bash
set -x
# shellcheck source=./scripts/common.bash
source "$(dirname "$0")/common.bash"

[ -n "$SKIP_CARGO" ] && exit

export RUSTUP_HOME="$XDG_DATA_HOME/rustup"
export CARGO_HOME="$XDG_DATA_HOME/cargo"

if [ -d "$RUSTUP_HOME" ] && [ -d "$CARGO_HOME" ]; then
    echo "rustc and cargo is already installed."
else
    echo "Installing rustc and cargo..."
    RUSTUP_HOME=$RUSTUP_HOME CARGO_HOME=$CARGO_HOME curl https://sh.rustup.rs -sSf | sh -s -- -y
fi

# shellcheck source=/dev/null
source "$CARGO_HOME/env"
rustup default stable
sudo PATH="$CARGO_HOME/bin:$PATH" /bin/sh "$REPO_DIR/config/cargo/install.sh"

