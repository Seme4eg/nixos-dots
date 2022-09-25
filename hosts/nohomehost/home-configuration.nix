# Specific system home-manager settings

{ config, inputs, pkgs, lib, ... }: {
  home-manager.users.${config.username} = {
    # default applications (to not create separate 'default' setting modules)
    home = {
      # REVIEW: do i need that?
      # username = "${user}"; # and if i define it how do i refer to it ?
      # homeDirectory = "/home/${user}";
      sessionVariables = {
        BROWSER = "qutebrowser";
        EDITOR = "emacs"; # nvim
      };

      packages = with pkgs; [
        # Shell script programmers are strange beasts. Writing programs in a language
        # that wasn't intended as a programming language. Alas, it is not for us mere
        # mortals to question the will of the ancient ones. If they want shell programs,
        # they get shell programs.
        shellcheck

        inputs.webcord.packages.${pkgs.system}.default

        # mpv
        mpv-with-scripts
        mpvc  # CLI controller for mpv

        font-manager   # so many damned fonts...
        # imagemagick    # for image manipulation from the shell

        # common lisp
        # sbcl
        # lispPackages.quicklisp

        lua

        scdl
        ffmpeg

        lf # REVIEW
      ];
    };

    modules = {
      desktop = {
        term.alacritty.enable = true; # TODO: try out st (have config ready)
        browsers.qutebrowser.enable = true;
        # desktop.browsers.firefox.enable = true; # TODO: setup maybe?
      };
      dev.node.enable = true;
      wayland = {
        enable = true;
        waybar.enable = true;
      };
      emacs.enable = true;
      # TODO: add vim module
      shell = {
        git.enable = true;
        zsh.enable = false;
      };
    };

  };
}
