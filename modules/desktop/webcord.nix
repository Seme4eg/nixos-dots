{ options, config, inputs, lib, pkgs, ... }:

let cfg = config.modules.desktop.webcord;
in {
  options.modules.desktop.webcord.enable = lib.mkEnableOption "webcord";

  config = lib.mkIf cfg.enable {
    user.packages = [
      inputs.webcord.packages.${pkgs.system}.default
    ];
  };
}
