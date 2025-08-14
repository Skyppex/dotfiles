{
  description = "skypex packages";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    zen-browser = {
      url = "github:MarceColl/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, zen-browser, rust-overlay, ... }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        system = system;
        config = { allowUnfree = true; };
        overlays = [ rust-overlay.overlays.default ];
      };

      dotnet = pkgs.buildEnv {
        name = "combined-dotnet-sdks";
        paths = [
          (with pkgs.dotnetCorePackages; combinePackages [ sdk_8_0 sdk_9_0 ])
        ];
      };

      rust = pkgs.rust-bin.stable.latest.default;

      cliTools = with pkgs; [
        astroterm
        awscli2
        bat
        btop
        cava
        chezmoi
        difftastic
        direnv
        docker
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
        rust
        skate
        slurp
        starship
        surrealdb
        tldr
        tree-sitter
        yazi
        zip
        zoxide
      ];

      commonDesktopTools = with pkgs; [
        bluetuith
        cliphist
        dbeaver-bin
        discord
        eww
        gimp
        grim
        hyprpicker
        hypridle
        hyprlock
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
        wezterm
        zen-browser
      ];

      homeDesktopTools = with pkgs; [ ani-cli ani-skip unityhub ];
    in {
      packages.${system} = {
        default = self.packages.${system}.home;

        shell = pkgs.buildEnv {
          name = "skypex-shell";
          paths = cliTools;
        };

        work = pkgs.buildEnv {
          name = "skypex-work";
          paths = cliTools ++ commonDesktopTools;
          nativeBuildInputs = [ pkgs.makeWrapper ];
          buildInputs = [ pkgs.libglvnd pkgs.mesa ];
          postBuild = ''
            wrapProgram $out/bin/wezterm \
                --prefix LD_LIBRARY_PATH : ${pkgs.libglvnd}/lib \
                --prefix LD_LIBRARY_PATH : ${pkgs.mesa}/lib
          '';
        };

        home = pkgs.buildEnv {
          name = "skypex-home";
          paths = cliTools ++ commonDesktopTools ++ homeDesktopTools;
          nativeBuildInputs = [ pkgs.makeWrapper ];
          buildInputs = [ pkgs.libglvnd pkgs.mesa ];
          postBuild = ''
            wrapProgram $out/bin/wezterm \
                --prefix LD_LIBRARY_PATH : ${pkgs.libglvnd}/lib \
                --prefix LD_LIBRARY_PATH : ${pkgs.mesa}/lib
          '';
        };
      };
    };
}
