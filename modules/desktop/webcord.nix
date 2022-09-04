{ options, config, inputs, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.desktop.webcord;
    inherit (inputs) webcord;
in {
  options.modules.desktop.webcord = with types; {
    enable = mkBoolOpt false;
  };

  # XXX: find a way to install webcord instead, but i guess ima need to make a
  # derivation for this
  config = mkIf cfg.enable {
    # environment.systemPackages = [ agenix.defaultPackage.x86_64-linux ];
    user.packages = [
      webcord.packages.${pkgs.system}.default
    ];
  };
}
