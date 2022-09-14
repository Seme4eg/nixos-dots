# modules/dev/common-lisp.nix --- https://common-lisp.net/
#
# Mostly for my stumpwm config, and the occasional dip into lisp gamedev.

{ config, options, lib, pkgs, ... }:

let devCfg = config.modules.dev;
    cfg = devCfg.common-lisp;
in {
  options.modules.dev.common-lisp.enable = lib.mkEnableOption "common-lisp";

  config = lib.mkIf cfg.enable {
    user.packages = with pkgs; [
      sbcl
      lispPackages.quicklisp
    ];
  };
}
