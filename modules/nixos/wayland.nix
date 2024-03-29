{ config, lib, pkgs, inputs, ... }: {
  options.modules.wayland.enable = lib.mkEnableOption "wayland";

  # NOTE: in case of problems with notifications check 'dbus-sway-environment'
  # and 'configure-gtk' here - https://nixos.wiki/wiki/Sway

  config = lib.mkIf config.modules.wayland.enable {

    programs = {
      hyprland = {
        enable = true;
        package = null;
      };
    };

    services.dbus.enable = true;

    # allow wayland lockers to unlock the screen
    security.pam.services.swaylock.text = "auth include login";

    xdg.portal = {
      enable = true;
      # wlroots screensharing
      wlr = {
        enable = true;
        settings.screencast = {
          chooser_type = "simple";
          chooser_cmd = "${pkgs.slurp}/bin/slurp -f %o -or";
        };
      };
    };

    # TODO: move it to themes later
    # Icons MS Nerdfont Icons override
    fonts = {
      # fontDir.enable = true;
      # enableGhostscriptFonts = true;
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

        # Material Design, all-the-icons, GitHub octicons, and a few others.
        emacs-all-the-icons-fonts

        (nerdfonts.override { fonts = [ "FiraCode" "JetBrainsMono" ]; })
      ];

      # Defaults listed here (including some for unicode coverage):
      # https://github.com/NixOS/nixpkgs/blob/master/nixos/modules/config/fonts/fonts.nix
      enableDefaultFonts = true;
      fontconfig.enable = true; # Allow fonts to be discovered

      # user defined fonts
      # the reason there's Noto Color Emoji everywhere is to override DejaVu's
      # B&W emojis that would sometimes show instead of some Color emojis
      fontconfig.defaultFonts = {
        serif = [ "Noto Serif" "Noto Color Emoji" ];
        sansSerif = [ "Noto Sans" "Noto Color Emoji" ];
        monospace = [ "JetBrainsMono Nerd Font" "Noto Color Emoji" ];
        emoji = [ "Noto Color Emoji" ];
      };
    };

    # This will allow brightness control from users in the video group.
    user.extraGroups = [ "video" ];
    # TODO: restores brighness level (from nighttime) in tty, which makes me c nothin
    hardware.brillo.enable = true;

    nix.settings = {
      substituters = [ "https://hyprland.cachix.org" ];
      trusted-public-keys = [
        "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
      ];
    };

    environment = {
      # Will automatically open hyprland when logged into tty1
      loginShellInit = ''
        [ -z $DISPLAY ] && [ "$(tty)" = "/dev/tty1" ] && exec Hyprland
      '';
    };

  };
}
