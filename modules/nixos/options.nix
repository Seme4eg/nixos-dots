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
    # REVIEW: maybe move it to flake.nix?
    username = lib.mkOption {
      type = lib.types.str;
      default = "nohome";
      description = "Primary account username";
    };

    # XXX: get rid of this
    home = {
      file       = mkOpt' attrs {} "Files to place directly in $HOME";
      configFile = mkOpt' attrs {} "Files to place in $XDG_CONFIG_HOME";
      dataFile   = mkOpt' attrs {} "Files to place in $XDG_DATA_HOME";
    };
  };

  config = {

    users.users.${config.username} = lib.mkAliasDefinitions options.user;

  };
}
