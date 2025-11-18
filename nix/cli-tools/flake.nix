{
  description = "skypex cli tools";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    rust-overlay,
    ...
  }: let
    system = "x86_64-linux";
    pkgsFree = import nixpkgs {
      system = system;
      config.allowUnfree = false;
      overlays = [rust-overlay.overlays.default];
    };

    pkgsUnfree = import nixpkgs {
      system = system;
      config.allowUnfree = true;
      overlays = [rust-overlay.overlays.default];
    };

    dotnet = pkgsFree.buildEnv {
      name = "combined-dotnet-sdks";
      paths = [
        (with pkgsFree.dotnetCorePackages;
            combinePackages [sdk_8_0 sdk_9_0])
      ];
    };

    #rust = pkgsFree.rust-bin.stable.latest.default;

    cliPackages = with pkgsUnfree; [
      astroterm
      awscli2
      cava
      fastfetch
      gitoxide
      ollama
      powershell
      starship
    ];

    cliPackagesLite = with pkgsUnfree; [
      astroterm
      cava
      fastfetch
      gitoxide
      starship
    ];

    cliPackagesFree = with pkgsFree; [
      bat
      btop
      chezmoi
      difftastic
      direnv
      docker
      dotnet
      fd
      file
      fzf
      gcc
      git
      github-cli
      gitleaks
      glow
      go
      gping
      gum
      hyperfine
      imagemagick
      inotify-tools
      jq
      jujutsu
      kubectl
      lazydocker
      lazygit
      lua
      gnumake
      man
      meson
      mods
      neovim
      nodejs
      nushell
      openssh
      pastel
      ripgrep
      #rust
      scc
      skate
      speedtest-cli
      tldr
      tree-sitter
      unzip
      yazi
      zip
      zoxide
    ];
  in {
    lib.${system} = {
      packages = cliPackagesFree ++ cliPackagesLite ++ cliPackages;
      packages-lite = cliPackagesFree ++ cliPackagesLite;
      packages-free = cliPackagesFree;
    };

    packages.${system} = {
      default = pkgsUnfree.buildEnv {
        name = "skypex-shell-packages";
        paths = self.lib.${system}.packages;
      };
    };

    devShells.${system} = {
      default = pkgsUnfree.mkShell {
        name = "skypex-shell";
        buildInputs = self.lib.${system}.packages;
      };

      lite = pkgsUnfree.mkShell {
        name = "skypex-shell-lite";
        buildInputs = self.lib.${system}.packages-lite;
      };

      free = pkgsFree.mkShell {
        name = "skypex-shell-free";
        buildInputs = self.lib.${system}.packages-free;
      };
    };
  };
}
