#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TEST_DIR="$(mktemp -d)"
trap 'rm -rf "$TEST_DIR"' EXIT

shellcheck \
    "$REPO_DIR/install.sh" \
    "$REPO_DIR/scripts/"*.bash \
    "$REPO_DIR/.chezmoiscripts/run_once_before_10_remove-legacy-editor-links.sh"
taplo check "$REPO_DIR/dot_config/mise/config.toml"
taplo get -f "$REPO_DIR/dot_config/mise/mise.lock" -o json >/dev/null
nixfmt --check "$REPO_DIR/flake.nix"

for yaml_file in \
    "$REPO_DIR/.github/workflows/"*.yaml \
    "$REPO_DIR/dot_codex/skills/dotfiles-maintenance/agents/openai.yaml"
do
    yq eval '.' "$yaml_file" >/dev/null
done

mkdir -p "$TEST_DIR/home/.config"
# Reproduce an existing installation whose application directories still point
# at the removed legacy source tree. Chezmoi must replace these broken links.
ln -s "$REPO_DIR/config/zsh" "$TEST_DIR/home/.config/zsh"
ln -s "$REPO_DIR/config/nvim" "$TEST_DIR/home/.config/nvim"
ln -s "$REPO_DIR/config/vim" "$TEST_DIR/home/.config/vim"
ln -s .config/zsh/.zshenv "$TEST_DIR/home/.zshenv"
ln -s .config/vim "$TEST_DIR/home/.vim"
# Native directories are deliberately non-exact so application-owned state is
# preserved across apply.
mkdir -p "$TEST_DIR/home/.config/wezterm/image"
touch "$TEST_DIR/home/.config/wezterm/image/local-state"
HOME="$TEST_DIR/home" sh "$REPO_DIR/.chezmoiscripts/run_once_before_10_remove-legacy-editor-links.sh"
test ! -e "$TEST_DIR/home/.vim"
test ! -e "$TEST_DIR/home/.config/vim"
chezmoi \
    --source "$REPO_DIR" \
    --destination "$TEST_DIR/home" \
    --config "$TEST_DIR/chezmoi.toml" \
    init --apply --promptDefaults --exclude scripts

test -d "$TEST_DIR/home/.config/zsh"
test ! -L "$TEST_DIR/home/.config/zsh"
test ! -L "$TEST_DIR/home/.config/nvim"
test -f "$TEST_DIR/home/.config/zsh/.zshrc"
test ! -e "$TEST_DIR/home/.config/zsh/.zshenv"
test -f "$TEST_DIR/home/.config/nvim/init.lua"
test -f "$TEST_DIR/home/.config/git/config"
test -f "$TEST_DIR/home/.config/mise/config.toml"
test -x "$TEST_DIR/home/.config/scripts/bin/fzf-find-executable"
test -x "$TEST_DIR/home/.config/tmux/pane-border-format.bash"
test -x "$TEST_DIR/home/.config/zeno/scripts/ansi.zsh"
test -e "$TEST_DIR/home/.zshenv"
test -f "$TEST_DIR/home/.zshenv"
test ! -L "$TEST_DIR/home/.zshenv"
test ! -e "$TEST_DIR/home/.vim"
test ! -e "$TEST_DIR/home/.config/vim"
test -f "$TEST_DIR/home/.config/wezterm/image/local-state"
test -f "$TEST_DIR/home/.codex/skills/dotfiles-maintenance/SKILL.md"
test ! -e "$TEST_DIR/home/.config/codex"
test ! -e "$TEST_DIR/home/README.md"
test ! -e "$TEST_DIR/home/flake.nix"
test ! -e "$TEST_DIR/home/config"
test ! -e "$TEST_DIR/home/scripts"
test ! -e "$TEST_DIR/home/.config/dotfiles/secrets/git.conf"
test ! -e "$TEST_DIR/home/.config/dotfiles/secrets/zsh.env"
test ! -e "$REPO_DIR/home"
test ! -e "$REPO_DIR/config"
test ! -e "$REPO_DIR/dot_config/zsh/.zcompdump"
test ! -e "$REPO_DIR/dot_config/zsh/.zshrc.local"
test ! -e "$REPO_DIR/dot_config/zsh/dot_zshenv"
test ! -e "$REPO_DIR/dot_config/vim"
test ! -e "$REPO_DIR/dot_config/navi/navi.log"

# The variables must expand inside the child Zsh, not in this Bash process.
# shellcheck disable=SC2016
env -u ZDOTDIR HOME="$TEST_DIR/home" zsh -d -c 'test "$ZDOTDIR" = "$HOME/.config/zsh"'
