{pkgs, ...}: {
  services.locate = {
    enable = true;
    package = pkgs.plocate;
  };

  services.usbmuxd.enable = true;

  services.logmein-hamachi.enable = true;
}
