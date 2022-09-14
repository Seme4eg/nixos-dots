{ config, options, lib, pkgs, ... }:

let cfg = config.modules.dev;
in {
  options.modules.dev.xdg.enable = lib.mkEnableOption "dev";

  config = lib.mkIf cfg.xdg.enable {
    # TODO
  };
}
