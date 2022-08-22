{ config, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.desktop.hyprland;
    configDir = config.dotfiles.configDir;
in {
  options.modules.desktop.hyprland = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    services.xserver = {
      enable = true;
        # layout = "us";
      displayManager = {
        lightdm.enable = false;
        gdm.enable = false;
      };
    };

    programs.hyprland.enable = true;

    user.packages = with pkgs; [
      alacritty
      mako
      hyprpaper
      waybar
      wlsunset
      brillo
      bemenu
    ];

    # programs.nm-applet.enable = true; # in case that didn't start in hyprland
    xdg.portal.wlr.enable = true;

    env = {
      CLUTTER_BACKEND = "wayland";
      XDG_SESSION_TYPE = "wayland";
      QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
      MOZ_ENABLE_WAYLAND = "1";
      QT_A_PLATFORM = "wayland";
      GDK_BACKEND = "wayland";
      _JAVA_AWT_WM_NONREPARENTING = "1";
      XCURSOR_SIZE = "24";
    };

    home.configFile = {
      # Write it recursively so other modules can link files in their dirs
      "hypr" = { source = "${configDir}/hypr"; recursive = true; };
    };

  };
}
