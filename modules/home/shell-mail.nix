{ config, options, lib, pkgs, ... }:

let
  name = "_ sad";
  maildir = "${config.xdg.dataHome}/.mail";
  # email = "edmund.a.miller@gmail.com";
  email = "sa6.mart1an@gmail.com";
  # email = "d3v1ant@mail.ru";
in {
  options.modules.shell.mail.enable = lib.mkEnableOption "mail";

  config = lib.mkIf config.modules.shell.mail.enable {
    packages = with pkgs; [ unstable.mu isync ];
    home = {
      accounts.email = {
        maildirBasePath = "${maildir}";
        accounts = {
          Gmail = {
            address = "${email}";
            userName = "${email}";
            flavor = "gmail.com";
            passwordCommand = "${pkgs.pass}/bin/pass Email/GmailApp";
            primary = true;
            # gpg.encryptByDefault = true;
            mbsync = {
              enable = true;
              create = "both";
              expunge = "both";
              patterns = [ "*" "[Gmail]*" ]; # "[Gmail]/Sent Mail" ];
            };
            realName = "${name}";
            msmtp.enable = true;
          };
          UTD = {
            address = "Edmund.Miller@utdallas.edu";
            userName = "eam150030@utdallas.edu";
            aliases = [ "eam150030@utdallas.edu" ];
            flavor = "plain";
            passwordCommand = "${pkgs.pass}/bin/pass utd";
            mbsync = {
              enable = true;
              create = "both";
              expunge = "both";
              patterns = [ "*" ];
            };
            imap = {
              host = "outlook.office365.com";
              port = 993;
              tls.enable = true;
            };
            realName = "${name}";
            msmtp.enable = true;
            smtp = {
              host = "smtp.office365.com";
              port = 587;
              tls.useStartTls = true;
            };
          };
        };
      };

      programs = {
        msmtp.enable = true;
        mbsync.enable = true;
      };

      services = {
        mbsync = {
          enable = true;
          frequency = "*:0/15";
          preExec = "${pkgs.isync}/bin/mbsync -Ha";
          postExec = "${pkgs.mu}/bin/mu index -m ${maildir}";
        };
      };
    };
  };
}
