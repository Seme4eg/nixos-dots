# modules/desktop/term/alacritty.nix

{ options, config, lib, pkgs, ... }:

let cfg = config.modules.desktop.term.alacritty;
in {
  options.modules.desktop.term.alacritty.enable = lib.mkEnableOption "alacritty";

  config = lib.mkIf cfg.enable {
    user.packages = with pkgs; [
      alacritty # gpu accelerated terminal
    ];

    env.TERMINAL = "alacritty";
  };
}
