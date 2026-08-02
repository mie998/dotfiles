#!/bin/sh
set -eu

REPOSITORY_URL="${DOTFILES_REPOSITORY_URL:-https://github.com/mie998/dotfiles.git}"
INSTALL_DIR="${DOTFILES_INSTALL_DIR:-$HOME/Work/dotfiles}"
PROFILE_LINK="${XDG_STATE_HOME:-$HOME/.local/state}/nix/profiles/dotfiles"

case "$(uname -s)" in
    Darwin)
        if [ "$(uname -m)" != arm64 ]; then
            echo "Only Apple Silicon macOS is supported." >&2
            exit 1
        fi
        ;;
    Linux) ;;
    *)
        echo "Only macOS and Ubuntu are supported." >&2
        exit 1
        ;;
esac

load_nix() {
    for profile_script in \
        /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh \
        "$HOME/.nix-profile/etc/profile.d/nix.sh"
    do
        if [ -r "$profile_script" ]; then
            # shellcheck disable=SC1090
            . "$profile_script"
            break
        fi
    done
}

if ! command -v nix >/dev/null 2>&1; then
    echo "Installing Nix..."
    if [ "$(uname -s)" = Linux ] && grep -qi microsoft /proc/sys/kernel/osrelease 2>/dev/null && [ ! -d /run/systemd/system ]; then
        curl -L https://nixos.org/nix/install | sh -s -- --no-daemon
    else
        curl -L https://nixos.org/nix/install | sh -s -- --daemon
    fi
    load_nix
fi

if ! command -v nix >/dev/null 2>&1; then
    echo "Nix was installed but is not available in this shell. Start a new shell and retry." >&2
    exit 1
fi

run_git() {
    if command -v git >/dev/null 2>&1; then
        git "$@"
    else
        nix --extra-experimental-features "nix-command flakes" shell nixpkgs#git -c git "$@"
    fi
}

if [ -e "$INSTALL_DIR" ]; then
    if [ ! -d "$INSTALL_DIR/.git" ]; then
        echo "$INSTALL_DIR exists but is not a Git repository; refusing to replace it." >&2
        exit 1
    fi
    run_git -C "$INSTALL_DIR" pull --ff-only
else
    mkdir -p "$(dirname "$INSTALL_DIR")"
    run_git clone "$REPOSITORY_URL" "$INSTALL_DIR"
fi

mkdir -p "$(dirname "$PROFILE_LINK")"
nix --extra-experimental-features "nix-command flakes" \
    build "path:$INSTALL_DIR#default" --out-link "$PROFILE_LINK"

PATH="$PROFILE_LINK/bin:$PATH"
export PATH

if [ -t 0 ]; then
    chezmoi --source "$INSTALL_DIR" init --apply
else
    chezmoi --source "$INSTALL_DIR" init --apply --promptDefaults
fi

echo "Dotfiles installed. Start a new login shell to activate the environment."
