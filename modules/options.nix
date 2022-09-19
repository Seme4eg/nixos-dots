  # Cross-cutting/general options (e.g. feature flags) go here.

{ config, options, lib, home-manager, ... }:

let
  inherit (lib.types) path attrs attrsOf oneOf str listOf either;

  mkOpt' = type: default: description:
    lib.mkOption { inherit type default description; };
in
{
  options = {
    user = lib.mkOption { type = lib.types.attrs; default = {}; };

    # Value for tracking where my username is used
    username = lib.mkOption {
      type = lib.types.str;
      default = "nohome";
      description = "Primary account username";
    };

    # REVIEW: why do we need that?
    home = {
      file       = mkOpt' attrs {} "Files to place directly in $HOME";
      configFile = mkOpt' attrs {} "Files to place in $XDG_CONFIG_HOME";
      dataFile   = mkOpt' attrs {} "Files to place in $XDG_DATA_HOME";
    };
  };

  config = {

    users.users.${config.username} = lib.mkAliasDefinitions options.user;

    # Install user packages to /etc/profiles instead. Necessary for
    # nixos-rebuild build-vm to work.
    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;

      # I only need a subset of home-manager's capabilities. That is, access to
      # its home.file, home.xdg.configFile and home.xdg.dataFile so I can deploy
      # files easily to my $HOME, but 'home-manager.users.nohome.home.file.*'
      # is much too long and harder to maintain, so I've made aliases in:
      #
      #   home.file        ->  home-manager.users.nohome.home.file
      #   home.configFile  ->  home-manager.users.nohome.home.xdg.configFile
      #   home.dataFile    ->  home-manager.users.nohome.home.xdg.dataFile
      users.${config.username} = {
        home = {
          file = lib.mkAliasDefinitions options.home.file;
          # Necessary for home-manager to work with flakes, otherwise it will
          # look for a nixpkgs channel.
          stateVersion = config.system.stateVersion;
        };
        xdg = {
          configFile = lib.mkAliasDefinitions options.home.configFile;
          dataFile   = lib.mkAliasDefinitions options.home.dataFile;
        };
      };
    };
  };
}
