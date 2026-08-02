# dotfiles

Apple Silicon macOS と Ubuntu（ネイティブ / WSL2、x86_64 / arm64）向けの dotfiles です。ホスト側の CLI は Nix、言語ランタイムと単体バイナリは mise、ホームディレクトリへの反映は chezmoi で管理します。Intel Mac と Windows ネイティブは対象外です。

## セットアップ

```sh
curl -fsSL https://mie998.github.io/dotfiles/install.sh | sh
```

このスクリプトは次の順序で処理します。

1. Nix がなければ公式 installer で導入する
2. リポジトリを `~/Work/dotfiles` に clone または fast-forward update する
3. `flake.nix` の package closure を専用 profile link に build する
4. chezmoi で dotfiles、mise 設定、Codex skill を反映する
5. chezmoi の onchange script から `mise install` を実行する

既存パスが Git repository でない場合、installer は削除せず停止します。Nix 自身の bootstrap に使う公式 installer だけが Nix 外の例外です。

旧 `home/` source 構成から更新した端末では、既存の chezmoi config が削除済みの source path を保持している可能性があります。更新後の初回だけは単独の `chezmoi apply` ではなく `./scripts/apply.bash` を実行し、repository root を source として再初期化してください。

アプリケーション設定の管理元は `dot_config/` だけです。chezmoi は各設定を `~/.config` 以下の通常ファイル・ディレクトリとして反映します。旧構成の `~/.config/<app>` シンボリックリンクは初回 apply で置き換えられます。

## 管理範囲

- Nix: chezmoi、mise、1Password CLI、Zsh、Vim、Neovim、Git、ビルドツールなど
- mise: Go、Python、Node.js LTS、Deno、Bun、Rust stable、および旧 cargo-binstall の単体 CLI
- chezmoi: `~/.config` の設定、`~/.zshenv`、グローバル Codex skill
- 既存方式を維持: Sheldon、VimのJetpack、Neovimのlazy.nvim・Mason

設定実体は`~/.config/zsh`と`~/.config/vim`に置き、ZshとVimが探索できるよう`~/.zshenv`と`~/.vim`だけを相対シンボリックリンクとして管理します。

GUI アプリ、Docker daemon / Docker Desktop、Wireshark の privileged integration、1Password GUI はホスト側の前提です。APT、Homebrew、cargo-binstall による fallback はありません。

## 日常操作

```sh
# Nix closure の再構築、chezmoi apply、必要な mise install
./scripts/apply.bash

# 変更確認
nix develop path:. -c ./scripts/check.bash

# chezmoi の差分だけ確認
chezmoi --source "$PWD" diff
```

アプリケーション設定は [dot_config](dot_config/)、ランタイム指定は [dot_config/mise/config.toml](dot_config/mise/config.toml)、ホスト package は [flake.nix](flake.nix) に追加します。設計上の制約は [AGENTS.md](AGENTS.md) にまとめています。

## 参考

- [Nix installation](https://nix.dev/install-nix)
- [mise backends](https://mise.jdx.dev/dev-tools/backends/)
