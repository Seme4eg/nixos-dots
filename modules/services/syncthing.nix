{ config, options, pkgs, lib, ... }:

# https://search.nixos.org/options?channel=unstable&show=services.syncthing.devices&from=0&size=50&sort=relevance&type=packages&query=syncthing

with lib;
with lib.my;
let cfg = config.modules.services.syncthing;
in {
  options.modules.services.syncthing = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [
      syncthing
      syncthingtray # https://github.com/Martchus/syncthingtray
    ];

    # TODO: setup secrets in agenix so the synchting runs automatically after
    # intallation
    services.syncthing = {
      enable = true;
      user = config.user.name;
      openDefaultPorts = true;
      guiAddress = "127.0.0.1:8384";

      overrideDevices = true;     # overrides any devices added or deleted through the WebUI
      overrideFolders = true;     # overrides any folders added or deleted through the WebUI
      devices = {
        "chost" = {
          id = "2VVN4XC-PHZEY3X-25YR2UO-DA7NPS5-ZKERYXM-UZGONF6-XUX7QNY-NLNYIAB";
          introducer = true;
          # autoAcceptFolders = true;
        };
        # TODO: temp
        "losedows" = {
          id = "4ZUEUZ5-FJX5LEY-DOZVVR6-IAIXVVQ-SEQJW5M-L3J7AAF-2BXNTQ7-INT2KAO";
        };
      };

      dataDir = "${config.user.home}"; # default path co add new dirs

      # REVIEW: any better way of defining config dir?
      configDir = "${config.user.home}/.config/syncthing";
      # configDir = "$XDG_CONFIG_HOME/syncthing";

      cert = config.age.secrets.syncthing-cert.path;
      key = config.age.secrets.syncthing-key.path;

      folders = {
        "${config.user.home}/Pictures" = {
          id = "xmx67-zj7wg";
          # label = ""
          devices = [ "chost" ];
          versioning = {type = "simple"; params.keep = "2";};
        };
        "${config.user.home}/Audiobooks" = {
          id = "oqlpo-zmwq9";
          # label = ""
          devices = [ "chost" ];
          versioning = {type = "simple"; params.keep = "1";};
        };
        "${config.user.home}/Books" = {
          id = "hkjpb-mmqwj";
          # label = ""
          devices = [ "chost" ];
          versioning = {type = "simple"; params.keep = "1";};
        };
        "${config.user.home}/Documents" = {
          id = "r7asu-23rtr";
          # label = ""
          devices = [ "chost" ];
          versioning = {type = "simple"; params.keep = "2";};
        };
        "${config.user.home}/git/books" = {
          id = "th5g5-5t9vc";
          # label = ""
          devices = [ "chost" ];
          versioning = {type = "simple"; params.keep = "1";};
        };
        "${config.user.home}/mem_arch" = {
          id = "9a4kl-cxrzf";
          # label = ""
          devices = [ "chost" ];
          versioning = {type = "simple"; params.keep = "3";};
        };
        "${config.user.home}/Music" = {
          id = "xxwgz-nsgrz";
          # label = ""
          devices = [ "chost" ];
          versioning = {type = "simple"; params.keep = "1";};
        };
        "${config.user.home}/git/tea" = {
          id = "uvxlq-9vwiq";
          # label = ""
          devices = [ "chost" ];
          versioning = {type = "simple"; params.keep = "2";};
        };

      };
    };
  };
}
