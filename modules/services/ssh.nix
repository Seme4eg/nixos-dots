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
      enable = true;
      kbdInteractiveAuthentication = false;
      passwordAuthentication = false;
    };

    user.openssh.authorizedKeys.keys =
      if config.user.name == "nohome"
        # XXX: recreate ssh key
      then [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAII769srJD8EfW/WfMLcSJQDlydkYtwBNzfQe50AYyMEF abracadabra@yes.com" ]
      # then [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIB71rSnjuC06Qq3NLXQJwSz7jazoB+umydddrxL6vg1a hlissner" ]

      else [];
  };
}
