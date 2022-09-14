# modules/desktop/media/graphics.nix

{ config, options, lib, pkgs, ... }:

let cfg = config.modules.desktop.graphics;
in {
  options.modules.desktop.graphics.enable = lib.mkEnableOption "graphics";

  config = lib.mkIf cfg.enable {
    user.packages = with pkgs; [
      font-manager   # so many damned fonts...
      imagemagick    # for image manipulation from the shell
    ];
  };
}
