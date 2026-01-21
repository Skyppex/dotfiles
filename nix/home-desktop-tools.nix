{
  pkgsUnfree,
  system,
  zen-browser,
}: let
  bottles = pkgsUnfree.bottles.override {
    removeWarningPopup = true;
  };
in
  with pkgsUnfree; [
    ani-cli
    ani-skip
    blender
    bottles
    catt
    logmein-hamachi
    prismlauncher
    r2modman
    zen-browser.packages.${system}.default
  ]
