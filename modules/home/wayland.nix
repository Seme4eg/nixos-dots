{ config, lib, pkgs, inputs, ... }: {
  options.modules.wayland.enable = lib.mkEnableOption "wayland";

  # NOTE: in case of problems with notifications check 'dbus-sway-environment'
  # and 'configure-gtk' here - https://nixos.wiki/wiki/Sway

  config = lib.mkIf config.modules.wayland.enable {

    # Hyprland nixos and home manager modules are complementary the nixos module
    # enables opengl, polkit and some other things the HM one hooks it up to
    # systemd optionally, and provides a way to specify the config file
    wayland.windowManager.hyprland.enable = true;

    home.packages = with pkgs; [
      # TODO: testing notifications with notify-send (remove when done setting up mako)
      # libnotify
      hyprpaper # background
      brillo    # brightness
      bemenu    # dmenu
      networkmanagerapplet

      # Screenshot
      grim
      slurp
      wl-clipboard

      # Screenlock
      swaylock

      # TODO: move to theme module
      # Taken from sway nixos.wiki page
      dracula-theme # gtk-theme
      # gnome3.adwaita-icon-theme # default gnome cursors
    ];

    # in case that didn't start in hyprland
    services.network-manager-applet.enable = true;

    home.sessionVariables = {
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

    # https://github.com/nix-community/home-manager/blob/master/modules/services/mako.nix#blob-path
    programs.mako = {
      enable = true;
      anchor = "top-center";
      borderRadius = 8;
      defaultTimeout = 5;
    };

    services.wlsunset = {
      enable = true;
      latitude = "33.9";
      longitude = "18.4";
      temperature.night = 3000;
    };

    services.swayidle = {
      enable = true;
      events = [
        {
          event = "before-sleep";
          command = "${pkgs.swaylock}/bin/swaylock -f -e -k -l -c 000000";
          # command = "${pkgs.swaylock-effects}/bin/swaylock -fF";
        }
        {
          event = "lock";
          command = "${pkgs.swaylock}/bin/swaylock -f -e -k -l -c 000000";
          # command = "${pkgs.swaylock-effects}/bin/swaylock -fF";
        }
      ];
      timeouts = [
        {
          timeout = 300;
          command = "${config.wayland.windowManager.hyprland.package}/bin/hyprctl dispatch dpms off";
          resumeCommand = "${config.wayland.windowManager.hyprland.package}/bin/hyprctl dispatch dpms on";
        }
        {
          timeout = 310;
          command = "${pkgs.systemd}/bin/loginctl lock-session";
        }
      ];
    };
    systemd.user.services.swayidle.Install.WantedBy =
      lib.mkForce ["hyprland-session.target"];

    xdg.configFile = {
      "hypr" = { source = "${inputs.self}/config/hypr"; recursive = true; };
      # TODO: doesn't work
      # "hypr/bindings".source =
      #   config.lib.file.mkOutOfStoreSymlink
      #     "${inputs.self}/config/hypr/bindings";
    };
  };
}
