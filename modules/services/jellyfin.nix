# Finally, a decent open alternative to Plex!

{ options, config, lib, pkgs, ... }:

let cfg = config.modules.services.jellyfin;
in {
  options.modules.services.jellyfin.enable = lib.mkEnableOption "jellyfin";

  config = lib.mkIf cfg.enable {
    services.jellyfin.enable = true;

    networking.firewall = {
      allowedTCPPorts = [ 8096 ];
      allowedUDPPorts = [ 8096 ];
    };

    user.extraGroups = [ "jellyfin" ];
  };
}
