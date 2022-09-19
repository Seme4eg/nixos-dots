{ config, lib, pkgs, inputs, ... }:

let cfg = config.modules.desktop.hyprland;
in {
  options.modules.desktop.hyprland.enable = lib.mkEnableOption "hyprland";

  # NOTE: in case of problems with notifications check 'dbus-sway-environment'
  # and 'configure-gtk' here - https://nixos.wiki/wiki/Sway

  config = lib.mkIf cfg.enable {
    services.xserver = {
      enable = true;
      displayManager = {
        lightdm.enable = false;
        gdm.enable = false;
      };
    };

    # NOTE: Waybar version, which allows for wlr/workspaces module
    nixpkgs.overlays = [
      (final: prev: {
        waybar = inputs.hyprland.packages.${final.system}.waybar-hyprland;
      })
    ];

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
      slurp
      wl-clipboard

      # Screenlock
      swayidle
      swaylock

      # Taken from sway nixos.wiki page
      dracula-theme # gtk-theme
      # gnome3.adwaita-icon-theme # default gnome cursors
    ];

    # TODO: move it to themes later
    # Icons MS Nerdfont Icons override
    fonts = {
      fontDir.enable = true;
      enableGhostscriptFonts = true;
      fonts = with pkgs; [
        # font-awesome dejavu_fonts symbola corefonts

        # icon fonts
        material-icons
        material-design-icons

        # normal fonts
        source-code-pro
        noto-fonts
        noto-fonts-cjk
        noto-fonts-emoji
        roboto

        (nerdfonts.override {
          fonts = [
            "FiraCode"
            "JetBrainsMono"
          ];
        })
      ];

      # use fonts specified by user rather than default ones
      enableDefaultFonts = false;

      # REVIEW: is it false or grue by default? Do i need it with below strings?
      # fontconfig.enable = true; # Allow fonts to be discovered

      # user defined fonts
      # the reason there's Noto Color Emoji everywhere is to override DejaVu's
      # B&W emojis that would sometimes show instead of some Color emojis
      fontconfig.defaultFonts = {
        serif = ["Noto Serif" "Noto Color Emoji"];
        sansSerif = ["Noto Sans" "Noto Color Emoji"];
        monospace = ["JetBrainsMono Nerd Font" "Noto Color Emoji"];
        emoji = ["Noto Color Emoji"];
      };

      # somwehere in above 'let .. in' construct:
      # fontList = [ "Sarasa Mono SC" "FantasqueSansMono Nerd Font Mono" ];
      # .. and then here maybe something like
      # fontconfig.defaultFonts = {
      #   monospace = fontList;
      #   sansSerif = fontList;
      #   serif = fontList;
      # };

    };

    # allow wayland lockers to unlock the screen
    security.pam.services.swaylock.text = "auth include login";

    programs.nm-applet.enable = true; # in case that didn't start in hyprland
    xdg.portal.wlr = {
      enable = true;
      settings.screencast = {
        chooser_type = "simple";
        chooser_cmd = "${pkgs.slurp}/bin/slurp -f %o -or";
      };
    };

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

      # use Wayland where possible
      NIXOS_OZONE_WL = "1"; # for webcord for example
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
      # Write it recursively so other modules can link files in their dirs
      "hypr" = { source = "${inputs.self}/config/hypr"; recursive = true; };
      "waybar" = { source = "${inputs.self}/config/waybar"; recursive = true; };
      # "waybar/config".source = config.lib.hm.file.mkOutOfStoreSymlink "${inputs.self}/config/waybar/config";
      # "waybar/style.css".source = config.lib.file.mkOutOfStoreSymlink
      #   "${inputs.self}/config/waybar/style.css";
    };
  };
}
