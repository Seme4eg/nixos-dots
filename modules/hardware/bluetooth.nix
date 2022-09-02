{ options, config, lib, pkgs, ... }:

with lib;
with lib.my;
let hwCfg = config.modules.hardware;
    cfg = hwCfg.bluetooth;
in {
  options.modules.hardware.bluetooth = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    hardware.bluetooth = {
      enable = true;
      # package = bluezFull;

      # hsphfpd.enable = true; #HSP & HFP daemon

      # https://nixos.wiki/wiki/Bluetooth#Enabling_A2DP_Sink
      settings = {
        General = {
          Enable = "Source,Sink,Media,Socket";
        };
      };
    };
  };
}
