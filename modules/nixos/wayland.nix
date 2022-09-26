{ config, lib, pkgs, inputs, ... }: {
  options.modules.wayland.enable = lib.mkEnableOption "wayland";

  # NOTE: in case of problems with notifications check 'dbus-sway-environment'
  # and 'configure-gtk' here - https://nixos.wiki/wiki/Sway

  config = lib.mkIf config.modules.wayland.enable {

    programs.hyprland.enable = true;
    services.dbus.enable = true;

    # allow wayland lockers to unlock the screen
    security.pam.services.swaylock.text = "auth include login";

    xdg.portal.wlr = {
      enable = true;
      settings.screencast = {
        chooser_type = "simple";
        chooser_cmd = "${pkgs.slurp}/bin/slurp -f %o -or";
      };
    };

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

    # This will allow brightness control from users in the video group.
    user.extraGroups = [ "video" ];
    # TODO: restores brighness level (from nighttime) in tty, which makes me c nothin
    hardware.brillo.enable = true;

    nix.settings = {
      substituters = ["https://hyprland.cachix.org"];
      trusted-public-keys = ["hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="];
    };

    environment = {
      # Will automatically open hyprland when logged into tty1
      loginShellInit = ''
          [ -z $DISPLAY ] && [ "$(tty)" = "/dev/tty1" ] && exec Hyprland
        '';
    };

  };
}
