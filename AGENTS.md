# Repository instructions

## Scope

- Target Apple Silicon macOS (`aarch64-darwin`) and Ubuntu on `x86_64` or `aarch64`.
- Treat Ubuntu under WSL2 as Linux. Do not add native Windows support.
- Use GPT-5.6-sol for architecture decisions and the default GPT-5.6-luna for implementation when those models are available.

## Ownership boundaries

- Use Nix for host packages and bootstrap tools. The official Nix installer is the only allowed package-install bootstrap outside Nix.
- Use mise, installed by Nix, for Go, Python, Node.js, Deno, Bun, Rust, and standalone developer binaries from the GitHub backend.
- Use chezmoi, installed by Nix, to apply home-directory state.
- Keep the existing Sheldon workflow for Zsh plugins.
- Keep the existing Jetpack workflow for classic Vim plugins.
- Keep the existing lazy.nvim and Mason workflows for Neovim plugins and editor tooling.
- Use 1Password CLI through chezmoi templates for secrets. Never put secret values in Git, Nix expressions, the Nix store, logs, or documentation.

Do not introduce APT, Homebrew, `cargo install`, cargo-binstall, rustup bootstrap, individual runtime curl installers, Home Manager, or nix-darwin as alternate managers. Host GUI applications, Docker daemon/Desktop, and privileged Wireshark integration are prerequisites outside this repository.

## Layout

- `flake.nix`: supported systems, host package set, development shell, and formatter.
- The repository root is the chezmoi source state. `.chezmoiignore` excludes repository-only files.
- `dot_config/`: the canonical chezmoi source for everything installed below `~/.config`.
- `dot_config/zsh/dot_zshenv`: the Zsh bootstrap installed at `~/.config/zsh/.zshenv`; the root `symlink_dot_zshenv.tmpl` exposes it as `~/.zshenv` so Zsh can establish `ZDOTDIR`.
- `dot_config/vim/`: classic Vim configuration exposed through the root `symlink_dot_vim.tmpl` compatibility link at `~/.vim`.
- `dot_config/mise/config.toml`: global runtime and standalone-binary inventory.
- Use chezmoi source-state names inside `dot_config`: `dot_` for target dotfiles and `executable_` for executable targets. Do not recreate a parallel `config/` tree or application-directory symlinks.
- `dot_codex/skills/dotfiles-maintenance/`: globally installed Codex skill at `~/.codex/skills/dotfiles-maintenance/`.
- `scripts/apply.bash`: rebuild the Nix package closure and apply chezmoi.
- `scripts/check.bash`: required local validation entrypoint.

`cargo-update` is intentionally absent: no binaries are managed by Cargo after this migration. Node uses `lts`; Rust uses `stable`; Go, Python, Deno, and Bun use `latest` because a common LTS alias is not available for all of them.

Use unstable nixpkgs for every supported target. Intel macOS (`x86_64-darwin`) is intentionally unsupported.

## Change workflow

1. Read this file and the dotfiles-maintenance skill reference before changing ownership boundaries.
2. Add host tools to `flake.nix` and runtime or standalone tools to the mise TOML, never both.
3. Preserve guards around optional shell commands so a partial bootstrap still opens Zsh.
4. Keep templates non-secret. Store only optional `op://vault/item/field` references in the machine-local chezmoi config.
5. Run `nix flake check path:.` and `nix develop path:. -c scripts/check.bash` when Nix is available.
6. For runtime inventory changes, also run `mise install` and verify `mise ls --missing` on at least one target platform.

Do not apply to the real home directory during tests. Use the temporary destination workflow in `scripts/check.bash`.
