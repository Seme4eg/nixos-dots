{ options, config, lib, pkgs, ... }:

let cfg = config.modules.desktop.steam;
in {
  options.modules.desktop.steam.enable = lib.mkEnableOption "steam";

  config = lib.mkIf cfg.enable {
    programs.steam.enable = true;

    # better for steam proton games
    systemd.extraConfig = "DefaultLimitNOFILE=1048576";
  };
}
