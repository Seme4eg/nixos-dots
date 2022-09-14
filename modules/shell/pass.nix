{ config, options, pkgs, lib, inputs, ... }:

let cfg = config.modules.shell.pass;
    inherit (inputs.self.lib) mkOpt;
in {
  options.modules.shell.pass = with lib.types; {
    enable = lib.mkEnableOption "pass";
    passwordStoreDir = mkOpt str "$HOME/.secrets/password-store";
  };

  config = lib.mkIf cfg.enable {
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
