{ config, lib, pkgs, inputs, ... }: {

  options.modules.wayland.waybar.enable = lib.mkEnableOption "hyprland";

  config = lib.mkIf config.modules.wayland.waybar.enable {
    programs.waybar = {
      enable = true;
      systemd = {
        enable = true;
        target = "graphical-session.target";
      };
      # style = import ./style.nix colors;
    };

    xdg.configFile = {
      "waybar/config".source = config.lib.file.mkOutOfStoreSymlink
        "${inputs.self}/config/waybar/config";
      "waybar/style.css".source = config.lib.file.mkOutOfStoreSymlink
        "${inputs.self}/config/waybar/style.css";
    };
  };
}
