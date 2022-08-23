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

    # services = {
    #   picom.enable = true;
    #   redshift.enable = true;
    #   xserver = {
    #     enable = true;
    #     displayManager = {
    #       lightdm.enable = true;
    #     #  lightdm.greeters.mini.enable = true;
    #     };
    #     windowManager.awesome.enable = true;
    #   };
    # };

    programs.hyprland.enable = true;

    user.packages = with pkgs; [
      alacritty # XXX move it away from here
      mako
      hyprpaper
      waybar
      wlsunset
      brillo
      bemenu
      swayidle
      swaylock
    ];

    # Icons MS Nerdfont Icons override
    fonts = {
      fontDir.enable = true;
      enableGhostscriptFonts = true; # XXX what's that
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
    };

    # Clean up leftovers, as much as we can (for X)
    # system.userActivationScripts.cleanupHome = ''
    #   pushd "${config.user.home}"
    #   rm -rf .compose-cache .nv .pki .dbus .fehbg
    #   [ -s .xsession-errors ] || rm -f .xsession-errors*
    #   popd
    # '';
  };
}
