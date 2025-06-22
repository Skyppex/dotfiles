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
    in
      {
      packages.x86_64-linux.default = nixpkgs.legacyPackages.x86_64-linux.buildEnv {
        name = "skypex-tools";
        paths = with pkgs; [
          astroterm
          btop
          cava
          chezmoi
          cliphist
          difftastic
          discord
          dotnet-runtime
          dotnet-sdk
          eww
          fd
          fzf
          gimp
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
          inkscape
          jetbrains-toolbox
          jq
          kubectl
          lazydocker
          lazygit
          lens
          lua
          mako
          meson
          mods
          mpv
          mpvpaper
          neovim
          nodejs
          noto-fonts-emoji
          nushell
          ollama
          openssh
          pastel
          rustup
          skate
          slack
          spotify
          starship
          thunderbird
          tldr
          tree-sitter
          unityhub
          yazi
          zen-browser
          zoxide
          powershell
          fastfetch
          man
          surrealdb
        ];
      };
    };
}
