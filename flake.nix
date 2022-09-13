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
    nixpkgs.url = "nixpkgs/nixos-unstable"; # primary nixpkgs
    nixpkgs-unstable.url = "nixpkgs/nixpkgs-unstable"; # for packages on the edge
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

  # Heart of the flake. It's a f-n that produces an attribute set and tells
  # flake which to use and what to do with the deps.
  # The @self argument denotes *this* flake. Its primarily useful for referring
  # to the source of the flake (as in 'src = self;') or to other outputs (e.g.
  # 'self.defaultPackage.x86_64-linux')
  # The attributes produced by 'outputs' are arbitrary values, except that (as we
  # saw above) there are some standard outputs such as defaultPackage.${system}.

  outputs = inputs @ { self, nixpkgs, nixpkgs-unstable, ... }:
    # Vars that can be used in the config files.
    let
      inherit (lib.my) mapModules mapModulesRec mapHosts;

      system = "x86_64-linux";

      # Function-wrapper to generate extended pkgs set with unstable & own
      # packages. Tho i don't understand it fully + i don't have own packages
      # for now.
      mkPkgs = pkgs: extraOverlays: import pkgs {
        inherit system;
        config.allowUnfree = true;  # forgive me Stallman senpai
        overlays = extraOverlays; # ++ (lib.attrValues self.overlays);
      };
      pkgs  = mkPkgs nixpkgs [ self.overlay ];
      pkgs' = mkPkgs nixpkgs-unstable [];

      # Extended lib set.
      lib = nixpkgs.lib.extend
        (self: super: { my = import ./lib { inherit pkgs inputs; lib = self; }; });

    in {
      lib = lib.my; # REVIEW: redefining global lib??

      overlay =
        final: prev: {
          unstable = pkgs';
          # my = self.packages."${system}";
        };

      # overlays =
      #   mapModules ./overlays import;

      # packages."${system}" =
      #   mapModules ./packages (p: pkgs.callPackage p {});

      # { dotfiles = import ./.; }
      nixosModules = mapModulesRec ./modules import;

      # --- New new format ---
      nixosConfigurations = mapHosts ./hosts {};

      # --- Old format ---
      # nixosConfigurations = (
      #   # location of configs, inports ./hosts/default.nix
      #   import ./hosts {
      #     inherit (nixpkgs) lib;
      #     # also inherit home-manager so it does not need to be defined here.
      #     inherit inputs user system home-manager;
      #   }
      # );

      # XXX: not sure if i need it
      devShell."${system}" =
        import ./shell.nix { inherit pkgs; };

      defaultApp."${system}" = {
        type = "app";
        program = ./bin/hey;
      };

    };
}
