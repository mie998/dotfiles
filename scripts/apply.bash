#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PROFILE_LINK="${XDG_STATE_HOME:-$HOME/.local/state}/nix/profiles/dotfiles"

ensure_runtime_dir() {
    runtime_probe="${XDG_RUNTIME_DIR:-}/.dotfiles-runtime-probe-$$"
    if [[ -n "${XDG_RUNTIME_DIR:-}" && -d "$XDG_RUNTIME_DIR" ]] && : > "$runtime_probe" 2>/dev/null; then
        rm -f "$runtime_probe"
        return
    fi

    XDG_RUNTIME_DIR="${XDG_STATE_HOME:-$HOME/.local/state}/runtime"
    mkdir -p "$XDG_RUNTIME_DIR"
    chmod 700 "$XDG_RUNTIME_DIR"
    export XDG_RUNTIME_DIR
}

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
CHEZMOI="$PROFILE_LINK/bin/chezmoi"
if [[ ! -x "$CHEZMOI" ]]; then
    echo "Nix package profile does not contain chezmoi: $CHEZMOI" >&2
    exit 1
fi

ensure_runtime_dir
"$CHEZMOI" --source "$REPO_DIR" init --apply "$@"
