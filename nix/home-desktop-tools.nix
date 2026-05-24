{
  pkgsUnfree,
  system,
  zen-browser,
}: let
in
  with pkgsUnfree; [
    ani-cli
    ani-skip
    blender
    catt
    prismlauncher
    r2modman
    signal-desktop
    zen-browser.packages.${system}.default
  ]
