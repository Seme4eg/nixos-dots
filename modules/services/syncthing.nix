{ config, options, pkgs, lib, ... }:

# https://search.nixos.org/options?channel=unstable&show=services.syncthing.devices&from=0&size=50&sort=relevance&type=packages&query=syncthing

with lib;
with lib.my;
let cfg = config.modules.services.syncthing;
in {
  options.modules.services.syncthing = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [
      syncthing
      syncthingtray # https://github.com/Martchus/syncthingtray
    ];

    # TODO: setup secrets in agenix so the synchting runs automatically after
    # intallation
    services.syncthing = {
      enable = true;
      user = config.user.name;
      openDefaultPorts = true;
      dataDir = "${config.user.home}";

      # configDir = "${config.user.home}/.config/syncthing";
      # configDir = "$XDG_CONFIG_HOME/syncthing";

      # key = "../../secrets/key.pem";
      # cert = scrt."syncthing/cert.pem".path;
      # key = scrt."syncthing/key.pem".path;

      # folders = {
      #   "/home/user/sync" = {
      #     id = "syncme";
      #     devices = [ "bigbox" ];
      #   };
      # };

      # Things to put in config?
      # devices.server.id = dp.syncthing.server.id;

    };

    home.configFile = {
      "syncthing" = {
        source = "${config.dotfiles.dir}/secrets/syncthing";
        recursive = true;
      };
    };


  };
}
