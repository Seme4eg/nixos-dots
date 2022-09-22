{ options, config, lib, pkgs, ... }:

let cfg = config.modules.desktop.term.alacritty;
in {
  options.modules.desktop.term.alacritty.enable = lib.mkEnableOption "alacritty";

  config = lib.mkIf cfg.enable {
    programs.alacritty.enable = true;

    home.sessionVariables.TERMINAL = "alacritty";
  };
}
