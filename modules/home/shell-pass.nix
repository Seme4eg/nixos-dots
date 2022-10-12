{ config, options, pkgs, lib, inputs, ... }: {
  options.modules.shell.pass.enable = lib.mkEnableOption "pass";
  config = lib.mkIf config.modules.shell.pass.enable {

    programs.gpg = {
      enable = true;
      homedir = "${config.xdg.dataHome}/gnupg";
    };

    services = {
      gpg-agent = {
        enable = true;
        # enableSshSupport = true;
        # sshKeys = [ "73D1C4271E8C508E1E55259660C94BE828B07738" ];
        # 'gnome3' requires `services.dbus.packages = [ pkgs.gcr ];``
        pinentryFlavor = "curses";
        extraConfig = ''
          allow-emacs-pinentry
        '';
      };
    };

    programs.password-store = {
      enable = true;
      # package = pkgs.pass.withExtensions (exts: [exts.pass-otp]);
      settings.PASSWORD_STORE_DIR = "${config.xdg.dataHome}/password-store";
    };
  };
}
