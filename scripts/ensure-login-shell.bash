#!/usr/bin/env bash
set -euo pipefail

profile_link="$1"
target_shell="$profile_link/bin/zsh"

if [[ ! -x "$target_shell" ]]; then
    echo "Nix-managed zsh is missing: $target_shell" >&2
    exit 1
fi

login_shell="${SHELL:-}"
if command -v getent >/dev/null 2>&1; then
    login_shell="$(getent passwd "$(id -un)" | cut -d: -f7)"
elif command -v dscl >/dev/null 2>&1; then
    login_shell="$(dscl . -read "/Users/$(id -un)" UserShell | awk '{print $2}')"
fi

if [[ "${login_shell##*/}" == zsh ]]; then
    exit 0
fi

echo "Changing the login shell to Nix-managed zsh: $target_shell"
if [[ -r /etc/shells ]] && ! grep -Fqx "$target_shell" /etc/shells; then
    echo "Registering Nix-managed zsh in /etc/shells"
    if ! command -v sudo >/dev/null 2>&1; then
        echo "sudo is required to add $target_shell to /etc/shells." >&2
        exit 1
    fi
    if ! printf '%s\n' "$target_shell" | sudo tee -a /etc/shells >/dev/null; then
        echo "Could not add $target_shell to /etc/shells." >&2
        exit 1
    fi
fi

if ! chsh -s "$target_shell"; then
    echo "Could not set the login shell to $target_shell." >&2
    exit 1
fi
