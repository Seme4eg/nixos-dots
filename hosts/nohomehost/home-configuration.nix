# Specific system home-manager settings

{ config, inputs, pkgs, lib, ... }:

let homeModules = inputs.self.lib.mkModules ../../modules/home; in
{
  home-manager.users.${config.username} = {
    imports = builtins.attrValues homeModules;
    modules = {
      desktop.term.alacritty.enable = true; # TODO: try out st (have config ready)
    };
  };
}
