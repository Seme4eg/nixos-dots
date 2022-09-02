{ options, config, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.desktop.discord;
in {
  options.modules.desktop.discord = with types; {
    enable = mkBoolOpt false;
  };

  # XXX: find a way to install webcord instead, but i guess ima need to make a
  # derivation for this
  config = mkIf cfg.enable {
    user.packages = with pkgs; [
      discord
    ];
  };
}
