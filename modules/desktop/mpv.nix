{ config, options, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.desktop.mpv;
in {
  options.modules.desktop.mpv = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [
      mpv-with-scripts
      mpvc  # CLI controller for mpv
    ];
  };
}
