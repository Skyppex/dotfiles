{
  pkgsFree,
  pkgsUnfree,
  fenix,
  dotnetSdks ? with pkgsFree.dotnetCorePackages; [sdk_8_0 sdk_9_0 sdk_10_0],
}: let
  dotnet = pkgsFree.buildEnv {
    name = "combined-dotnet-sdks";
    paths = [(pkgsFree.dotnetCorePackages.combinePackages dotnetSdks)];
  };

  rust = with fenix;
    combine [
      (stable.withComponents [
        "rustc"
        "cargo"
        "rustfmt"
        "clippy"
        "rust-src"
        "rust-docs"
        "rust-std"
        "rust-analyzer"
      ])
    ];

  cliPackages = with pkgsUnfree; [
    awscli2
    powershell
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
    gnumake
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
    man
    meson
    mods
    neovim
    nix-output-monitor
    nodejs
    nushell
    nvd
    openssh
    pastel
    ripgrep
    rust
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
in rec {
  packages = cliPackagesFree ++ cliPackagesLite ++ cliPackages;
  packages-lite = cliPackagesFree ++ cliPackagesLite;
  packages-free = cliPackagesFree;

  devShells = {
    default = pkgsUnfree.mkShell {
      name = "skypex-shell";
      buildInputs = packages;
    };

    lite = pkgsUnfree.mkShell {
      name = "skypex-shell-lite";
      buildInputs = packages-lite;
    };

    free = pkgsFree.mkShell {
      name = "skypex-shell-free";
      buildInputs = packages-free;
    };
  };
}
