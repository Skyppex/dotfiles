{pkgs, ...}: {
  services.locate = {
    enable = true;
    package = pkgs.plocate;
  };

  services.logmein-hamachi.enable = true;
}
