{ config, options, lib, home-manager, ... }:

let
  inherit (lib.types) path attrs attrsOf oneOf str listOf either;

  mkOpt = type: default:
    lib.mkOption { inherit type default; };

  mkOpt' = type: default: description:
    lib.mkOption { inherit type default description; };
in
{
  options = {
    user = mkOpt lib.types.attrs {};

    dotfiles = {
      dir = mkOpt path
        (lib.removePrefix "/mnt"
          (lib.findFirst lib.pathExists (toString ../.) [
            "/mnt/etc/dotfiles"
            "/etc/dotfiles"
          ]));
      binDir     = mkOpt path "${config.dotfiles.dir}/bin";
      configDir  = mkOpt path "${config.dotfiles.dir}/config";
      modulesDir = mkOpt path "${config.dotfiles.dir}/modules";
      themesDir  = mkOpt path "${config.dotfiles.modulesDir}/themes";
    };

    # REVIEW: why do we need that?
    home = {
      file       = mkOpt' attrs {} "Files to place directly in $HOME";
      configFile = mkOpt' attrs {} "Files to place in $XDG_CONFIG_HOME";
      dataFile   = mkOpt' attrs {} "Files to place in $XDG_DATA_HOME";
    };

    # Values in this 'env' are being exported in extraInit option (see end of
    # this file)
    env = lib.mkOption {
      # Option type, providing type-checking and value merging.
      type = attrsOf (oneOf [ str path (listOf (either str path)) ]);
      # Convert option value to something else
      apply = lib.mapAttrs
        (n: v: if lib.isList v
               then lib.concatMapStringsSep ":" (x: toString x) v
               else (toString v));
      default = {};
      description = "TODO";
    };
  };

  config = {
    user =
      # to set up USER env var just define it in shell
      let user = builtins.getEnv "USER";
          name = if lib.elem user [ "" "root" ] then "nohome" else user;
      in {
        inherit name;
        description = "The primary user account";
        extraGroups = [ "wheel" ];
        isNormalUser = true;
        home = "/home/${name}";
        group = "users";
      };

    # Install user packages to /etc/profiles instead. Necessary for
    # nixos-rebuild build-vm to work.
    home-manager = {
      useUserPackages = true;

      # I only need a subset of home-manager's capabilities. That is, access to
      # its home.file, home.xdg.configFile and home.xdg.dataFile so I can deploy
      # files easily to my $HOME, but 'home-manager.users.nohome.home.file.*'
      # is much too long and harder to maintain, so I've made aliases in:
      #
      #   home.file        ->  home-manager.users.nohome.home.file
      #   home.configFile  ->  home-manager.users.nohome.home.xdg.configFile
      #   home.dataFile    ->  home-manager.users.nohome.home.xdg.dataFile
      users.${config.user.name} = {
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

    users.users.${config.user.name} = lib.mkAliasDefinitions options.user;

    nix.settings = let users = [ "root" config.user.name ]; in {
      trusted-users = users;
      allowed-users = users;
    };

    # must already begin with pre-existing PATH. Also, can't use binDir here,
    # because it contains a nix store path.
    env.PATH = [ "$DOTFILES_BIN" "$XDG_BIN_HOME" "$PATH" ];

    # Shell script code called during global environment initialisation after
    # all variables and profileVariables have been set.
    environment.extraInit =
      lib.concatStringsSep "\n"
        (lib.mapAttrsToList (n: v: "export ${n}=\"${v}\"") config.env);
  };
}
