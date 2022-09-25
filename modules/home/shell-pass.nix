{ config, options, pkgs, lib, inputs, ... }: {
  options.modules.shell.pass.enable = lib.mkEnableOption "pass";
  config = lib.mkIf config.modules.shell.pass.enable {

    programs.password-store = {
      enable = true;
      # package = pkgs.pass.withExtensions (exts: [exts.pass-otp]);
      settings.PASSWORD_STORE_DIR = "${config.xdg.dataHome}/password-store";
    };
  };
}
