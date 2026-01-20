{lib, ...}: let
  sshDir = ./ssh;

  pubFiles =
    lib.filter
    (name: lib.hasSuffix ".pub" name)
    (builtins.attrNames (builtins.readDir sshDir));

  pubKeyStrings =
    map (name: builtins.readFile (builtins.concatStringsSep "/" [sshDir name])) pubFiles;
in {
  services.openssh.enable = true;

  system.activationScripts.linkSshKeys = {
    text = ''
      mkdir -p /home/tower/.ssh
      chmod 700 /home/tower/.ssh
      ${lib.concatStringsSep "\n" (map (f: "ln -sf ${f} /home/tower/.ssh/") (map
        (name: builtins.concatStringsSep "/" [sshDir name])
        pubFiles))}
      chown -R tower /home/tower/.ssh
    '';
  };

  users.users.tower = {
    openssh.authorizedKeys.keys = pubKeyStrings;
  };

  users.users.root = {
    openssh.authorizedKeys.keys = pubKeyStrings;
  };

  programs.ssh.extraConfig = "AddKeysToAgent yes";
}
