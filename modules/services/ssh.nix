{ options, config, lib, ... }:

with lib;
with lib.my;
let cfg = config.modules.services.ssh;
in {
  options.modules.services.ssh = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    services.openssh = {
      enable = true; # same as 'services.sshd.enable'
      kbdInteractiveAuthentication = false;
      passwordAuthentication = false;
    };

    programs.ssh.startAgent = true;

    user.openssh.authorizedKeys.keys =
      if config.user.name == "nohome"
      then [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKNMu4qZ3UH/F2qH9b2dkiujAttr/IvQZVJcBtntYhJo 418@duck.com" ]
      else [];
  };
}
