{ config, options, pkgs, lib, ... }:

with lib;
with lib.my;
let cfg = config.modules.shell.pass;
in {
  options.modules.shell.pass = with types; {
    enable = mkBoolOpt false;
    passwordStoreDir = mkOpt str "$HOME/.secrets/password-store";
  };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [
      pass
      # (pass.withExtensions (exts: [
      #   exts.pass-otp
      #   exts.pass-genphrase
      # ] ++ (if config.modules.shell.gnupg.enable
      #       then [ exts.pass-tomb ]
      #       else [])))
    ];
    env.PASSWORD_STORE_DIR = cfg.passwordStoreDir;
  };

  # TODO: copy gpg key from another machine to this one, put it in agenix and
  # add my password-store repo?
}
