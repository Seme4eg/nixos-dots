{ config, options, pkgs, lib, ... }: {
  options.modules.services.syncthing.enable = lib.mkEnableOption "syncthing";

  config = lib.mkIf config.modules.services.syncthing.enable {
    environment.systemPackages = [ pkgs.syncthing ];

    # https://search.nixos.org/options?channel=unstable&show=services.syncthing.devices&from=0&size=50&sort=relevance&type=packages&query=syncthing

    services.syncthing = {
      enable = true;
      user = config.username;
      openDefaultPorts = true;
      guiAddress = "127.0.0.1:8384";
      # override any devices/folders added or deleted through the WebUI
      overrideDevices = true;
      overrideFolders = true;

      devices = {
        "chost" = {
          id = "2VVN4XC-PHZEY3X-25YR2UO-DA7NPS5-ZKERYXM-UZGONF6-XUX7QNY-NLNYIAB";
          introducer = true;
          # autoAcceptFolders = true;
        };
      };

      dataDir = "/home/${config.username}"; # default path co add new dirs

      # REVIEW: any better way of defining config dir?
      configDir = "/home/${config.username}/.config/syncthing";

      cert = config.age.secrets.syncthing-cert.path;
      key = config.age.secrets.syncthing-key.path;

      folders = {
        "/home/${config.username}/Pictures" = {
          id = "xmx67-zj7wg";
          devices = [ "chost" ];
          versioning = {type = "simple"; params.keep = "2";};
        };
        "/home/${config.username}/Audiobooks" = {
          id = "oqlpo-zmwq9";
          devices = [ "chost" ];
          versioning = {type = "simple"; params.keep = "1";};
        };
        "/home/${config.username}/Books" = {
          id = "hkjpb-mmqwj";
          devices = [ "chost" ];
          versioning = {type = "simple"; params.keep = "1";};
        };
        "/home/${config.username}/Documents" = {
          id = "r7asu-23rtr";
          devices = [ "chost" ];
          versioning = {type = "simple"; params.keep = "2";};
        };
        "/home/${config.username}/git/books" = {
          id = "th5g5-5t9vc";
          devices = [ "chost" ];
          versioning = {type = "simple"; params.keep = "1";};
        };
        "/home/${config.username}/mem_arch" = {
          id = "9a4kl-cxrzf";
          devices = [ "chost" ];
          versioning = {type = "simple"; params.keep = "3";};
        };
        "/home/${config.username}/Music" = {
          id = "xxwgz-nsgrz";
          devices = [ "chost" ];
          versioning = {type = "simple"; params.keep = "1";};
        };
        "/home/${config.username}/git/tea" = {
          id = "uvxlq-9vwiq";
          devices = [ "chost" ];
          versioning = {type = "simple"; params.keep = "2";};
        };

      };
    };
  };
}
