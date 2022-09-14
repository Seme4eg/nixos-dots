# modules/dev/lua.nix --- https://www.lua.org/

{ config, options, lib, pkgs, ... }:

let cfg = config.modules.dev.lua;
in {
  options.modules.dev.lua.enable = lib.mkEnableOption "lua";

  config = lib.mkIf cfg.enable {
    user.packages = with pkgs; [
      lua
      # luaPackages.moonscript
    ];
  };
}
