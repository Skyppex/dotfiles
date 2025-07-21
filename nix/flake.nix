{
  description = "skypex packages";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    zen-browser = {
      url = "github:MarceColl/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, zen-browser, ... }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        system = system;
        config = { allowUnfree = true; };
      };

      dotnet = pkgs.buildEnv {
        name = "combined-dotnet-sdks";
        paths = [
          (with pkgs.dotnetCorePackages; combinePackages [ sdk_8_0 sdk_9_0 ])
        ];
      };

      commonTools = with pkgs; [
        astroterm
        awscli2
        bat
        btop
        cava
        chezmoi
        difftastic
        direnv
        dotnet
        fastfetch
        fd
        file
        fzf
        git
        github-cli
        gitleaks
        gitoxide
        glow
        go
        gping
        grim
        gum
        hyperfine
        imagemagick
        jq
        kubectl
        lazydocker
        lazygit
        lua
        man
        meson
        mods
        neovim
        nodejs
        nushell
        ollama
        openssh
        pastel
        powershell
        ripgrep
        rustup
        skate
        slurp
        starship
        surrealdb
        tldr
        tree-sitter
        unityhub
        yazi
        zip
        zoxide
      ];

      desktopOnlyTools = with pkgs; [
        bluetuith
        cliphist
        discord
        eww
        gimp
        grim
        inkscape
        jetbrains-toolbox
        lens
        mako
        mpv
        mpvpaper
        neovim
        noto-fonts-emoji
        slack
        spotify
        thunderbird
        unityhub
        zen-browser
      ];
    in {
      packages.${system} = {
        default = self.packages.${system}.desktop;

        desktop = pkgs.buildEnv {
          name = "skypex-tools";
          paths = commonTools ++ desktopOnlyTools;
        };

        wsl = pkgs.buildEnv {
          name = "skypex-tools-wsl";
          paths = commonTools;
        };
      };
    };
}
