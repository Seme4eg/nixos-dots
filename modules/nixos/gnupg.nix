{ config, options, lib, pkgs, ... }:

let cfg = config.modules.shell.gnupg;
in {
  options.modules.shell.gnupg.enable = lib.mkEnableOption "gnupg";

  config = lib.mkIf cfg.enable {
    environment.variables.GNUPGHOME = "$XDG_CONFIG_HOME/gnupg";

    programs.gnupg.agent.enable = true;
    # agent.enableSSHSupport = true;

    # HACK Without this config file you get "No pinentry program" on 20.03.
    #      programs.gnupg.agent.pinentryFlavor doesn't appear to work, and this
    #      is cleaner than overriding the systemd unit.
    # home.configFile."gnupg/gpg-agent.conf" = {
    #   text = ''
    #     default-cache-ttl ${toString cfg.cacheTTL}
    #     pinentry-program ${pkgs.pinentry.gtk2}/bin/pinentry
    #   '';
    # };
  };
}