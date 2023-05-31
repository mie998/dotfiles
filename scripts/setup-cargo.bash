
#!/usr/bin/env bash
set -x
# shellcheck source=./scripts/common.bash
source "$(dirname "$0")/common.bash"

[ -n "$SKIP_CARGO" ] && exit

export RUSTUP_HOME="$XDG_DATA_HOME/rustup"
export CARGO_HOME="$XDG_DATA_HOME/cargo"

if [ -d "$CARGO_DATA_DIR" ]; then
    echo "rustc and cargo is already installed."
    # shellcheck source=/dev/null
else
    echo "Installing rustc and cargo..."
    RUSTUP_HOME=$RUSTUP_HOME CARGO_HOME=$CARGO_HOME curl https://sh.rustup.rs -sSf | sh -s -- -y
fi


