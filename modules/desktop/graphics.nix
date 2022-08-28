# modules/desktop/media/graphics.nix

{ config, options, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.desktop.graphics;
in {
  options.modules.desktop.graphics = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [
      font-manager   # so many damned fonts...
      imagemagick    # for image manipulation from the shell
    ];
  };
}
