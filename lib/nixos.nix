{ inputs, lib, pkgs, ... }:

with lib;
with lib.my;
let sys = "x86_64-linux"; # default system in case 'system' wasn't passed
in {
  # Returns nixosSystem set. For now attrs are unused
  mkHost = path: attrs @ { system ? sys, ... }:
    nixosSystem {
      inherit system;
      specialArgs = { inherit lib inputs system; };
      modules = [
        {
          nixpkgs.pkgs = pkgs;
          # make current dirname (in hosts/) a hostname
          networking.hostName = mkDefault (removeSuffix ".nix" (baseNameOf path));
        }
        # Filter an attribute set by removing all attributes for which the given
        # predicate returns FALSE. For now this logic isn't needed since 'attrs'
        # in all calls to this function are '{}'
        # (filterAttrs (n: v: !elem n [ "system" ]) attrs)
        attrs

        # file with general settings applicable to all hosts
        ../hosts   # /hosts/default.nix

        (import path)
      ];
    };

  # attrs param is unused. Returns a set with format
  # { { name = "nohomehost", value = <setCreatedWithTheAboveFunction>} }
  mapHosts = dir: attrs @ { system ? system, ... }:
    mapModules dir
      (hostPath: mkHost hostPath attrs);
}

# Initial format was
# nohomehost = lib.nixosSystem {
#    inherit system;
#    # put here things we've set ourselfes ??? didn't get it
#    specialArgs = { inherit user inputs; }; # pass flake variable
#    modules = [
#      ./nohomehost
#      ./configuration.nix

#      home-manager.nixosModules.home-manager {
#        home-manager.useGlobalPkgs = true;
#        home-manager.useUserPackages = true;
#        home-manager.extraSpecialArgs = { inherit user; }; # pass flake var
#        home-manager.users.${user} = {
#          imports = [(import ./home.nix)] ++ [(import ./nohomehost/home.nix)];
#        };
#      }
#    ];
#  };
