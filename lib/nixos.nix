inputs:
with inputs.nixpkgs.lib;
let
  inherit (import ./modules.nix inputs) mapModules;

  mkHost = path:
    nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit inputs; }; # XXX: remove this line
      modules = [
        {
          nixpkgs.pkgs = inputs.self.pkgs;
          # make current dirname (in hosts/) a hostname
          networking.hostName = mkDefault
            (removeSuffix ".nix" (baseNameOf path));
        }
        # file with general settings applicable to all hosts
        ../hosts   # /hosts/default.nix
        (import path)
      ];
    };

  # Returns a set:
  # { { name = "nohomehost", value = <setCreatedWithTheAboveFunction>} }
  mapHosts = dir: mapModules dir (hostPath: mkHost hostPath);
in
{ inherit mapHosts; }
