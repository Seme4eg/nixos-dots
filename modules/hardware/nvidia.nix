{ options, config, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.hardware.nvidia;
in {
  options.modules.hardware.nvidia = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    hardware = {
      nvidia = {
        modesetting.enable = true;
        package = let nv = config.boot.kernelPackages.nvidiaPackages; in
                  if lib.versionAtLeast nv.stable.version nv.beta.version
                  then nv.stable else nv.beta;
      };
      opengl = {
        enable = true;
        driSupport = true;
        driSupport32Bit = true;
        extraPackages = with pkgs; [
          vaapiVdpau
          libvdpau-va-gl
          nvidia-vaapi-driver
        ];
        # extraPackages32 = with pkgs.pkgsi686Linux; [
        #   vaapiVdpau
        #   libvdpau-va-gl
        #   nvidia-vaapi-driver
        # ]
      };
    };

    # yes, driver config is under 'services.xserver' because nobody has the
    # balls to rename it. (c) viper
    services.xserver.videoDrivers = [ "nvidia" ];

    env = {
        LIBVA_DRIVER_NAME = "nvidia";
        GBM_BACKEND = "nvidia-drm";
        __GLX_VENDOR_LIBRARY_NAME = "nvidia";
        WLR_NO_HARDWARE_CURSORS = "1";
        WLR_RENDERER = "vulkan";
    };

    environment.systemPackages = with pkgs; [
        # Respect XDG conventions, damn it!
        (writeScriptBin "nvidia-settings" ''
        #!${stdenv.shell}
        mkdir -p "$XDG_CONFIG_HOME/nvidia"
        exec ${config.boot.kernelPackages.nvidia_x11.settings}/bin/nvidia-settings --config="$XDG_CONFIG_HOME/nvidia/settings"
      '')
      ];
    };
}
