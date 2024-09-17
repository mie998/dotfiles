#!/usr/bin/env bash

if command -v mise &> /dev/null
then
    echo "mise already installed!!"
    exit 0
fi

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
"$MISE_INSTALL_PATH" use -g usage

# nodejs
"$MISE_INSTALL_PATH" install node@lts
"$MISE_INSTALL_PATH" use --global node@lts

# restart shell for path activate
exec $SHELL -l
