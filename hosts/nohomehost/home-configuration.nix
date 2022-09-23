# Specific system home-manager settings

{ config, inputs, pkgs, lib, ... }:

let homeModules = inputs.self.lib.mkModules ../../modules/home; in
{
  home-manager.users.${config.username} = {
    imports = builtins.attrValues homeModules;

    # default applications (to not create separate 'default' setting modules)
    home.sessionVariables = {
      BROWSER = "qutebrowser";
      EDITOR = "emacs"; # nvim
    };

    modules = {
      desktop = {
        term.alacritty.enable = true; # TODO: try out st (have config ready)
        browsers.qutebrowser.enable = true;
      };
      # shell.zsh.enable = false;
    };
  };
}
