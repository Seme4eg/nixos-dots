{ options, config, inputs, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.desktop.webcord;
    inherit (inputs) webcord;
in {
  options.modules.desktop.webcord = with types; {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    user.packages = [
      webcord.packages.${pkgs.system}.default
    ];

    env.NIXOS_OZONE_WL = "1"; # for webcord on wayland
  };
}
