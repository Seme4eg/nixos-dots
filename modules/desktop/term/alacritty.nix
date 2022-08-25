# modules/desktop/term/st.nix
#
# I like (x)st. This appears to be a controversial opinion; don't tell anyone,
# mkay?

{ options, config, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.desktop.term.st;
in {
  options.modules.desktop.term.alacritty = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [
      alacritty # gpu accelerated terminal
    ];
  };
}
