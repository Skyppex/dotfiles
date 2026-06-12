{...}: {
  virtualisation.oci-containers.backend = "podman";

  imports = [
    (import ./minecraft-server.nix {})
  ];

  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
    dockerSocket.enable = true;
  };

  # virtualisation.libvirtd = {
  #   enable = true;
  #
  #   qemu.vhostUserPackages = with pkgs; [
  #     virtiofsd
  #   ];
  # };

  # programs.virt-manager.enable = true;
}
