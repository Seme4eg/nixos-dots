{ options, config, lib, ... }:

let cfg = config.modules.hardware.audio;
in {
  options.modules.hardware.audio.enable = lib.mkEnableOption "audio";

  config = lib.mkIf cfg.enable {
    # hardware.pulseaudio.package = pulseaudioFull;
    # hardware.pulseaudio.enable = true;
    # hardware.pulseaudio.support32Bit = true;

    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };

    # allow pulseaudio to acquire realtime priority
    security.rtkit.enable = true;
    sound.enable = true;
    # sound.mediaKeys.enable = true;

    # TODO: set this thing up
    # environment.systemPackages = with pkgs; [
    #   easyeffects
    # ];

    # HACK Prevents ~/.esd_auth files by disabling the esound protocol module
    #      for pulseaudio, which I likely don't need. Is there a better way?
    # hardware.pulseaudio.configFile =
    #   let inherit (pkgs) runCommand pulseaudio;
    #       paConfigFile =
    #         runCommand "disablePulseaudioEsoundModule"
    #           { buildInputs = [ pulseaudio ]; } ''
    #             mkdir "$out"
    #             cp ${pulseaudio}/etc/pulse/default.pa "$out/default.pa"
    #             sed -i -e 's|load-module module-esound-protocol-unix|# ...|' "$out/default.pa"
    #           '';
    #   in mkIf config.hardware.pulseaudio.enable
    #     "${paConfigFile}/default.pa";

    user.extraGroups = [ "audio" ]; # "pulseaudio" ?
  };
}
