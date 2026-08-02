# Architecture reference

## Supported systems

- macOS: `aarch64-darwin` (Apple Silicon only)
- Ubuntu native or WSL2: `aarch64-linux`, `x86_64-linux`
- Native Windows is unsupported.

## Ownership matrix

| Concern | Owner | Source |
|---|---|---|
| Host and bootstrap CLI | Nix | `flake.nix` |
| Language runtimes | mise | `dot_config/mise/config.toml` |
| Standalone developer binaries | mise GitHub backend | same mise TOML |
| Home-directory state | chezmoi | repository-root source-state entries |
| Secrets | 1Password CLI + chezmoi templates | machine-local `op://` references |
| Zsh plugins | Sheldon | `dot_config/sheldon/plugins.toml` |
| Neovim plugins and tools | lazy.nvim + Mason | `dot_config/nvim/` |

Use unstable nixpkgs for every supported target. Intel macOS (`x86_64-darwin`) is unsupported.

Nix is bootstrapped only with the official Nix installer. Do not add APT, Homebrew, Cargo, or direct runtime-install fallbacks. GUI applications and daemons remain host prerequisites.

## Apply sequence

1. Validate OS and architecture.
2. Install Nix if absent.
3. Clone or fast-forward the repository without deleting an existing path.
4. Build the flake's default package to the dedicated profile link.
5. Initialize and apply chezmoi.
6. Let the chezmoi onchange script run `mise install`.
7. Start a new login shell.

Application configuration lives only in `dot_config/` and chezmoi installs it as normal files and directories below `~/.config`. Do not add a parallel `config/` tree or application-directory symlinks. Encode target dotfiles with `dot_` and executable targets with `executable_`. Keep application directories non-exact so machine-local runtime state such as `.zshrc.local`, plugin data, and generated caches is not removed by apply.

`dot_zshenv` is the only required home-root shell bootstrap and is installed as a regular `~/.zshenv` file. It sets the XDG variables before setting `ZDOTDIR=$XDG_CONFIG_HOME/zsh`; subsequent interactive Zsh configuration comes from `dot_config/zsh/dot_zshrc`. Classic Vim, `~/.vim`, and Jetpack are not managed. Neovim with lazy.nvim and Mason is the sole terminal editor workflow.

## Version policy

- Node.js: `lts`
- Rust: `stable`
- Go, Python, Deno, Bun: `latest` stable
- Standalone tools: `latest`, installed from explicit GitHub Release backends
- Nix packages: pinned by `flake.lock`

`cargo-update` is removed with Cargo-managed global binaries. Update the mise TOML instead.

## Secret policy

Commit only templates and example `op://vault/item/field` references. Never commit resolved values, service-account tokens, or generated private files. Keep generated files private and make 1Password optional so non-interactive CI can render the source state without authentication.
