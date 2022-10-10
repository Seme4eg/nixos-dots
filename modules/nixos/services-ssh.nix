{ options, config, lib, ... }:

let cfg = config.modules.services.ssh;
in {
  options.modules.services.ssh.enable = lib.mkEnableOption "ssh";

  config = lib.mkIf cfg.enable {
    services.openssh = {
      enable = true; # same as 'services.sshd.enable'
      passwordAuthentication = false;
      # useDns = true; # #openvpn?
    };

    programs.ssh.startAgent = true;

    user.openssh.authorizedKeys.keys = if config.username == "nohome" then
      [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKNMu4qZ3UH/F2qH9b2dkiujAttr/IvQZVJcBtntYhJo 418@duck.com"
      ]
    else
      [ ];
  };
}
