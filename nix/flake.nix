{
  description = "skypex packages";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    zen-browser = {
      url = "github:MarceColl/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, zen-browser, ... }: 
    let 
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        system = system;
        config = {
          allowUnfree = true;
        };
      };

    isWSL = builtins.getEnv "WSL_DISTRO_NAME" != "";

      commonTools = with pkgs; [
        astroterm
        btop
        cava
        chezmoi
        difftastic
        direnv
        dotnet-runtime
        dotnet-sdk
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
        starship
        surrealdb
        tldr
        tree-sitter
        unityhub
        yazi
        zoxide
      ];

      desktopOnlyTools = with pkgs; [
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

      finalTools = if isWSL then
        commonTools
      else
        commonTools ++ desktopOnlyTools;
    in
      {
      packages.x86_64-linux.default = nixpkgs.legacyPackages.x86_64-linux.buildEnv {
        name = "skypex-tools";
        paths = finalTools;
      };
    };
}
