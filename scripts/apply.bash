#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PROFILE_LINK="${XDG_STATE_HOME:-$HOME/.local/state}/nix/profiles/dotfiles"

if [[ $(uname -s) == Darwin && $(uname -m) != arm64 ]]; then
    echo "Only Apple Silicon macOS is supported." >&2
    exit 1
fi

if ! command -v nix >/dev/null 2>&1; then
    echo "Nix is required. Run ./install.sh first." >&2
    exit 1
fi

mkdir -p "$(dirname "$PROFILE_LINK")"
nix --extra-experimental-features "nix-command flakes" \
    build "path:$REPO_DIR#default" --out-link "$PROFILE_LINK"

export PATH="$PROFILE_LINK/bin:$PATH"
chezmoi --source "$REPO_DIR" init --apply "$@"
