---
name: dotfiles-maintenance
description: Maintain the mie998 dotfiles repository and its global developer environment. Use when Codex works on this dotfiles repository, changes macOS or Ubuntu setup, adds or updates Nix packages, mise runtimes or standalone binaries, chezmoi state, 1Password-backed configuration, Zsh, Neovim, or repository bootstrap and validation.
---

# Dotfiles maintenance

Maintain the environment without crossing its package-manager ownership boundaries.

## Workflow

1. Locate the repository. Prefer the current Git root; otherwise check `~/Work/dotfiles`.
2. Read the repository's `AGENTS.md` before editing.
3. Read [references/architecture.md](references/architecture.md) when changing packages, runtimes, bootstrap, secrets, or chezmoi topology.
4. Inspect the existing implementation and working tree. Preserve unrelated and machine-local changes.
5. Put host packages in Nix, runtimes and standalone developer binaries in mise, and home state in chezmoi.
6. Preserve Sheldon for Zsh plugins and lazy.nvim/Mason for Neovim plugins and editor tooling.
7. Keep secret values out of source and the Nix store; use optional 1Password references in chezmoi templates.
8. Run the repository validation commands from `AGENTS.md`. Test chezmoi against a temporary destination, never the real home directory.

When a requested change conflicts with these boundaries, explain the conflict and propose an in-boundary implementation.
