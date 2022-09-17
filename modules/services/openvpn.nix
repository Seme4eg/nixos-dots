{ config, lib, pkgs, ... }:

with lib;
let cfg = config.modules.services.openvpn;
in {
  options.modules.services.openvpn.enable = lib.mkEnableOption "openvpn";

  config = mkIf cfg.enable {

    # Taken from here: https://github.com/jollheef/localhost/blob/master/networking.nix#L65
    # Secrets file example is also in this repo
    services.openvpn.servers.vpn = {
      # autoStart = true;
      config = ''
        config ${config.age.secrets.ovpn-conf.path}
        ca ${config.age.secrets.ovpn-crt.path}
        tls-auth ${config.age.secrets.ovpn-key.path} 1
      '';
      # TODO: breaks my internet if i enable these
      # authUserPass.username = "user";
      # authUserPass.password = "pass";
      updateResolvConf = true;
    };

    systemd = {
      services = {
        # ntpd.serviceConfig.TimeoutStopSec = 5;

        "openvpn-restart-after-suspend" = {
          description = "Restart OpenVPN after suspend";
          after = [ "suspend.target" "hibernate.target" "hybrid-sleep.target" ];
          wantedBy = [ "suspend.target" "hibernate.target" "hybrid-sleep.target" ];
          script = "${pkgs.systemd}/bin/systemctl try-restart openvpn-vpn.service";
        };
        "openvpn-keep-alive" = {
          description = "Make sure OpenVPN connection is alive";
          after = [ "openvpn-vpn.service" ];
          wantedBy = [ "openvpn-vpn.service" ];
          script = ''
          while [ 1 ]; do
            sleep 10s
            timeout 10s ${pkgs.iputils}/bin/ping -c1 1.1.1.1 >/dev/null 2>&1 || \
              ${pkgs.systemd}/bin/systemctl try-restart openvpn-vpn.service
          done
        '';
        };
      };
    };

  };
}
