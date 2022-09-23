{ options, config, inputs, lib, pkgs, ... }:

let cfg = config.modules.desktop.gaming;
    # inherit (inputs) gaming;
in {
  options.modules.desktop.gaming.enable = lib.mkEnableOption "gaming";

  config = lib.mkIf cfg.enable {

    # TODO: check fufexan gaming module to make this one better

    programs = {
      steam = {
        enable = true;
        #remotePlay.openFirewall = true; # Ports for Stream Remote Play
      };
      # Better gaming performance
      # Steam: Right-click game - Properties - Launch options: gamemoderun %command%
      # Lutris: General Preferences ->
      #   - Enable Feral GameMode
      #   - Global options - Add Environment Variables: LD_PRELOAD=/nix/store/*-gamemode-*-lib/lib/libgamemodeauto.so
      gamemode = {
        enable = true; # TODO: https://search.nixos.org/options?channel=unstable&show=programs.gamemode.settings&from=0&size=50&sort=relevance&type=packages&query=gamemode
        settings = {
          general = {
            softrealtime = "auto";
            # GameMode can renice game processes. You can put any value between
            # 0 and 20 here, the value will be negated and applied as a nice
            # value (0 means no change). Defaults to 0.
            # renice = "15";
          };
          gpu = {
            apply_gpu_optimisations = "accept-responsibility";
          };
        };
      };
      # man (8) gamemode
    };

    # better for steam proton games
    systemd.extraConfig = "DefaultLimitNOFILE=1048576";

    # TODO: when yall b into gaming on this machine
    # user.packages = with pkgs; [
      # lutris
      # heroic
      # polymc
    # ];

    # REVIEW: will it work?
    # add gaming cache
    nix.settings = {
      substituters = ["https://nix-gaming.cachix.org"];
      trusted-public-keys = ["nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4="];
    };

  };
}
