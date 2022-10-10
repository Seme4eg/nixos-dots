# Specific system home-manager settings

{ config, inputs, pkgs, lib, ... }: {
  home-manager.users.${config.username} = {
    # default applications (to not create separate 'default' setting modules)
    home = {
      sessionVariables = {
        BROWSER = "firefox";
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
        # error: 'mpv-with-scripts' has been renamed to/replaced by 'self.wrapMpv'
        # mpv-with-scripts
        mpvc # CLI controller for mpv

        font-manager # so many damned fonts...
        # imagemagick    # for image manipulation from the shell

        # common lisp
        # sbcl
        # lispPackages.quicklisp

        lua

        scdl
        ffmpeg
      ];
    };

    modules = {
      desktop = {
        term.alacritty.enable = true; # TODO: try out st (have config ready)
        # browsers.qutebrowser.enable = true;
        browsers.firefox.enable = true;
      };
      dev.node.enable = true;
      wayland = {
        enable = true;
        waybar.enable = true;
      };
      emacs.enable = true;
      # TODO: add vim module
      shell = {
        # adl.enable = true;
        # vaultwarden.enable = true; # lightweigt client for bitwarden
        git.enable = true;
        zsh.enable = true;
        pass.enable = true;
      };
    };

    xdg.enable = true;

    editorconfig = {
      enable = true;
      settings = {
        "*" = {
          charset = "utf-8";
          end_of_line = "lf";
          trim_trailing_whitespace = true;
          insert_final_newline = true;
          max_line_width = 80;
          indent_style = "space";
          indent_size = 2;
        };
      };
    };

    services = {
      easyeffects.enable = true;
      playerctld.enable = true;
    };
  };
}
