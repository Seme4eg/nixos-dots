# Cross-cutting/general options (e.g. feature flags) go here.

{ config, options, lib, ... }: {
  options = {
    user = lib.mkOption { type = lib.types.attrs; default = {}; };

    # Value for tracking where my username is used, using it in hm and nixos
    username = lib.mkOption {
      type = lib.types.str;
      default = "nohome";
      description = "Primary account username";
    };
  };

  config = {
    # Alias 'users.users.<user>' -> 'user'
    users.users.${config.username} = lib.mkAliasDefinitions options.user;
  };
}
