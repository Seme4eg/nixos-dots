# modules/dev/lua.nix --- https://www.lua.org/

{ config, options, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.dev.lua;
in {
  options.modules.dev.lua = {
    enable = mkBoolOpt false;
  };

  config = (mkIf cfg.enable {
    user.packages = with pkgs; [
      lua
      # luaPackages.moonscript
    ];
  });
}
