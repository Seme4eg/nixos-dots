# flake.nix --- the starting point
#
# Author:  seme4eg / _sad
# URL:     https://github.com/Seme4eg/nix-dots
# License: MIT
#
# Welcome to the abyss.

{
  description = "Sad nixos dots, writing which made me even more sad, rip..";

  # Specify flakes that this my flake depends on. These are fetched by Nix and
  # passed as arguments to the 'outputs' function.
  inputs = {
    # Core dependencies
    nixpkgs.url = "nixpkgs/nixos-unstable"; # for packages on the edge
    home-manager = {
      url = "github:nix-community/home-manager"; # .. or  github:rycee/home-manager/master
      inputs.nixpkgs.follows = "nixpkgs";
    };
    agenix.url = "github:ryantm/agenix";
    agenix.inputs.nixpkgs.follows = "nixpkgs";

    # Extras
    emacs-overlay.url = "github:nix-community/emacs-overlay";
    nixos-hardware.url = "github:nixos/nixos-hardware";
    hyprland = {
      url = "github:hyprwm/Hyprland";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    webcord.url = "github:fufexan/webcord-flake";
  };

  # The @self argument denotes *this* flake. Its primarily useful for referring
  # to the source of the flake (as in 'src = self;') or to other outputs (e.g.
  # 'self.defaultPackage.x86_64-linux')
  # The attributes produced by 'outputs' are arbitrary values, except that (as
  # we saw above) there are some standard outputs such as
  # defaultPackage.${system}.

  outputs = inputs @ { self, nixpkgs, ... }:
    # Vars that can be used in the config files.
    let
      lib = import ./lib inputs;
      inherit (lib) mapModulesRec mapHosts; # mapModules

      system = "x86_64-linux";

      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };

    in {
      inherit lib pkgs;

      # overlays =
      #   mapModules ./overlays import;

      # packages."${system}" =
      #   mapModules ./packages (p: pkgs.callPackage p {});

      nixosModules = mapModulesRec ./modules import;

      nixosConfigurations = mapHosts ./hosts;

      # XXX: not sure if i need it
      # devShell."${system}" =
      #   import ./shell.nix { inherit pkgs; };

      defaultApp."${system}" = {
        type = "app";
        program = ./bin/hey;
      };

    };
}
