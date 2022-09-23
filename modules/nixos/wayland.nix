{ config, lib, pkgs, inputs, ... }: {
  options.modules.wayland.enable = lib.mkEnableOption "wayland";

  # NOTE: in case of problems with notifications check 'dbus-sway-environment'
  # and 'configure-gtk' here - https://nixos.wiki/wiki/Sway

  config = lib.mkIf config.modules.wayland.enable {

    programs.hyprland.enable = true;
    services.dbus.enable = true;

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

    environment = {
      # Will automatically open hyprland when logged into tty1
      loginShellInit = ''
          [ -z $DISPLAY ] && [ "$(tty)" = "/dev/tty1" ] && exec Hyprland
        '';
      # XXX: remove it and leave those that r in hm module
      variables = {
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
    };

  };
}
