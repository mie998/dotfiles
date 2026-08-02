{
  description = "Cross-platform dotfiles packages for macOS and Ubuntu";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  nixConfig = {
    extra-experimental-features = [
      "nix-command"
      "flakes"
    ];
  };

  outputs =
    {
      nixpkgs,
      ...
    }:
    let
      supportedSystems = [
        "aarch64-darwin"
        "aarch64-linux"
        "x86_64-linux"
      ];
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
      packagesFor =
        system:
        import nixpkgs {
          inherit system;
          config.allowUnfreePredicate = pkg: builtins.elem (nixpkgs.lib.getName pkg) [ "1password-cli" ];
        };
      dotfilesPackage =
        pkgs:
        let
          commonPackages = with pkgs; [
            _1password-cli
            autoconf
            bashInteractive
            chezmoi
            clang
            clang-tools
            cmake
            coreutils
            curl
            direnv
            docker-client
            docker-compose
            file
            findutils
            fzf
            gh
            ghq
            git
            git-lfs
            gnumake
            gnugrep
            gnupg
            gnused
            jq
            lazygit
            mise
            neovim
            openssl
            openssl.dev
            pinentry-curses
            pkg-config
            shellcheck
            sqlite
            sqlite.dev
            tmux
            trash-cli
            tree
            unzip
            vim
            wget
            yq-go
            zip
            zsh
          ];
          platformPackages =
            if pkgs.stdenv.isDarwin then with pkgs; [ pinentry_mac ] else with pkgs; [ xclip ];
        in
        pkgs.buildEnv {
          name = "dotfiles-packages";
          paths = commonPackages ++ platformPackages;
          extraOutputsToInstall = [ "man" ];
          meta.description = "Nix-managed host tools for this dotfiles repository";
        };
    in
    {
      packages = forAllSystems (
        system:
        let
          pkgs = packagesFor system;
        in
        {
          default = dotfilesPackage pkgs;
        }
      );

      devShells = forAllSystems (
        system:
        let
          pkgs = packagesFor system;
        in
        {
          default = pkgs.mkShellNoCC {
            packages = with pkgs; [
              chezmoi
              mise
              nixfmt
              shellcheck
              taplo
              yq-go
              zsh
            ];
          };
        }
      );

      formatter = forAllSystems (system: (packagesFor system).nixfmt);
    };
}
