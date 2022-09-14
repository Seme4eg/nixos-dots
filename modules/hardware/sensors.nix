{ options, config, lib, pkgs, ... }:

let cfg = config.modules.hardware.sensors;
in {
  options.modules.hardware.sensors.enable = lib.mkEnableOption "sensors";

  config = lib.mkIf cfg.enable {
    user.packages = [ pkgs.lm_sensors ];
  };
}
