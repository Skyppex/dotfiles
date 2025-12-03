{
  pkgsFree,
  pkgsUnfree,
}: let
  dotnet = pkgsFree.buildEnv {
    name = "combined-dotnet-sdks";
    paths = [
      (with pkgsFree.dotnetCorePackages;
          combinePackages [sdk_8_0 sdk_9_0])
    ];
  };
in
  with pkgsUnfree; [
    dotnet
    dbeaver-bin
  ]
