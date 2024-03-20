#!/usr/bin/env bash
set -x
# shellcheck source=./scripts/common.bash
source "$(dirname "$0")/common.bash"

[ -n "$SKIP_MISE" ] && exit

export MISE_DATA_DIR="$XDG_DATA_HOME/mise"
export MISE_INSTALL_PATH="$MISE_DATA_DIR/bin/mise"
export MISE_CACHE_DIR="$XDG_CACHE_HOME/mise"

echo "Installing Mise..."
curl https://mise.run | sh

echo "Install mise completions..."
mkdir -p "$XDG_DATA_HOME/zsh/completions"
"$MISE_INSTALL_PATH" completions zsh > "$XDG_DATA_HOME/zsh/completions/_mise"

# nodejs
"$MISE_INSTALL_PATH" install node@lts
"$MISE_INSTALL_PATH" use --global node@lts

# golang
"$MISE_INSTALL_PATH" install go@1.22.1
"$MISE_INSTALL_PATH" use --global go@1.22.1

# python
"$MISE_INSTALL_PATH" install python@3.12.2
"$MISE_INSTALL_PATH" use --global python@3.12.2
