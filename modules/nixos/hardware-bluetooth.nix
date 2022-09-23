{ options, config, lib, ... }:

let hwCfg = config.modules.hardware;
    cfg = hwCfg.bluetooth;
in {
  options.modules.hardware.bluetooth.enable = lib.mkEnableOption "bluetooth";

  config = lib.mkIf cfg.enable {
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

    # services = {                            # Applets
    #   blueman-applet.enable = true;         # Bluetooth
    # };

    # > bluetooth audio
    # don't forget to enable bluetooth module in hardware file first
    # services.blueman.enable = true;

  };
}
