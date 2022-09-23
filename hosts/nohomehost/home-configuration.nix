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
    };

    modules = {
      desktop = {
        term.alacritty.enable = true; # TODO: try out st (have config ready)
        browsers.qutebrowser.enable = true;
      };
      shell = {
        git.enable = true;
        # zsh.enable = false;
      };
    };

  };
}
