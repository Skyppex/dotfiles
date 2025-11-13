{pkgs, ...}: {
  virtualisation.docker = {
    enable = true;
    daemon.settings = {
      dns = ["1.1.1.1" "8.8.8.8"];
      log-driver = "journald";

      default-address-pools = [
        {
          base = "172.30.0.0/16";
          size = 24;
        }
      ];

      storage-driver = "overlay2";
    };
  };

  virtualisation.libvirtd = {
    enable = true;

    qemu.vhostUserPackages = with pkgs; [
      virtiofsd
    ];
  };

  programs.virt-manager.enable = true;
}
