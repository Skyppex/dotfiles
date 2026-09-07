{pkgs, ...}: {
  # https://devenv.sh/packages/
  packages = with pkgs; [
    stylua
    yamlfmt
    yamllint
    tombi
    jq
    vscode-json-languageserver
    xmlformat
    shellcheck
    kdePackages.qtdeclarative
    ruff
    pyright
    beautysh
    nixd
    alejandra
  ];

  # https://devenv.sh/languages/
  languages.lua.enable = true;
  languages.nix.enable = true;
}
