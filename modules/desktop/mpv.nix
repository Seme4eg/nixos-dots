{ config, options, lib, pkgs, ... }:

let cfg = config.modules.desktop.mpv;
in {
  options.modules.desktop.mpv.enable = lib.mkEnableOption "mpv";

  config = lib.mkIf cfg.enable {
    user.packages = with pkgs; [
      mpv-with-scripts
      mpvc  # CLI controller for mpv
    ];
  };
}
