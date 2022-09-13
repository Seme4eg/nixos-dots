{ options, config, inputs, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.desktop.webcord;
in {
  options.modules.desktop.webcord = with types; {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    user.packages = [
      inputs.webcord.packages.${pkgs.system}.default
    ];
  };
}
