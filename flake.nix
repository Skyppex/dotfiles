{
  description = "flake for developing my dotfiles";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    fenix = {
      url = "github:nix-community/fenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    nixpkgs,
    flake-utils,
    fenix,
    ...
  }:
    flake-utils.lib.eachDefaultSystem (system: let
      # system = "x86_64-linux";
      pkgs = import nixpkgs {inherit system;};

      fenixLib = fenix.packages.${system};
      rust-toolchain = with fenixLib;
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
    in {
      devShells.default = pkgs.mkShell {
        packages = with pkgs; [
          rust-toolchain
          lua-language-server
          stylua
          yamlfmt
          yamllint
          tombi
          jq
          vscode-json-languageserver
          xmlformat
          markdownlint-cli
          shellcheck
          kdePackages.qtdeclarative
          ruff
          pyright
          beautysh
          nixd
          alejandra
        ];
      };
    });
}
