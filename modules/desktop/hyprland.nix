{ config, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.desktop.hyprland;
    configDir = config.dotfiles.configDir;
in {
  options.modules.desktop.hyprland = {
    enable = mkBoolOpt false;
  };

  # NOTE: in case of problems with notifications check 'dbus-sway-environment'
  # and 'configure-gtk' here - https://nixos.wiki/wiki/Sway

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
    services.dbus.enable = true;

    user.packages = with pkgs; [
      mako      # notifications
      # TODO: testing notifications with notify-send (remove when done setting up mako)
      libnotify
      hyprpaper # background
      waybar    # bar
      wlsunset  # nightlight
      brillo    # brightness
      bemenu    # dmenu
      networkmanagerapplet

      # Screenshot
      grim
      slock
      wl-clipboard

      # Screenlock
      swayidle
      swaylock

      # Taken from sway nixos.wiki page
      dracula-theme # gtk-theme
      # gnome3.adwaita-icon-theme # default gnome cursors
    ];

    programs.waybar.enable = true;

    # TODO: move it to themes later
    # Icons MS Nerdfont Icons override
    fonts = {
      fontDir.enable = true;
      enableGhostscriptFonts = true;
      fonts = with pkgs; [
        source-code-pro
        font-awesome
        dejavu_fonts
        symbola
        corefonts
        (nerdfonts.override {
          fonts = [
            "FiraCode"
          ];
        })
      ];
    };

    programs.nm-applet.enable = true; # in case that didn't start in hyprland
    xdg.portal.wlr.enable = true;

    # This will allow brightness control from users in the video group.
    user.extraGroups = [ "video" ];
    hardware.brillo.enable = true;

    # > bluetooth audio
    # don't forget to enable bluetooth module in hardware file first
    # services.blueman.enable = true;

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

    # modules.theme.onReload.bspwm = ''
    #   ${pkgs.bspwm}/bin/bspc wm -r
    #   source $XDG_CONFIG_HOME/bspwm/bspwmrc
    # '';

    # systemd.user.services."dunst" = {
    #   enable = true;
    #   description = "";
    #   wantedBy = [ "default.target" ];
    #   serviceConfig.Restart = "always";
    #   serviceConfig.RestartSec = 2;
    #   serviceConfig.ExecStart = "${pkgs.dunst}/bin/dunst";
    # };

    home.configFile = {
      # "sxhkd".source = "${configDir}/sxhkd"; # XXX
      # Write it recursively so other modules can link files in their dirs
      "hypr" = { source = "${configDir}/hypr"; recursive = true; };
      # I don't need it to be hardlink cuz i need setwp.sh to work
      "hypr/hyprpaper.conf".text = ''
        preload = ~/Pictures/atmosphere/Wadim Kashin/wadim-kashin-3.jpg
        wallpaper = eDP-1,~/Pictures/atmosphere/Wadim Kashin/wadim-kashin-3.jpg
      '';
      "waybar" = { source = "${configDir}/waybar"; recursive = true; };
    };

    system.userActivationScripts.setupWallpapers = ''
      pushd "~/.config/hypr"
      [ ! -f "hyprpaper.conf" ] && touch hyprpaper.conf
      popd
    '';

    # TODO: fix swaylock and swayidle not letting me log back in, move locking
    # setup from autorun.sh to systemd service (tho it might not b working then
    # on other systems...)
    # systemd = {
    #   services = {
    #     "force-lock-after-suspend" = {
    #       serviceConfig.User = "user";
    #       description = "Force xsecurelock after suspend";
    #       before = [ "suspend.target" "hibernate.target" "hybrid-sleep.target" ];
    #       wantedBy = [ "suspend.target" "hibernate.target" "hybrid-sleep.target" ];
    #       script = ''
    #       DISPLAY=:0 ${pkgs.xsecurelock}/bin/xsecurelock
    #     '';
    #     };
    #   };
    # };
  };
}
