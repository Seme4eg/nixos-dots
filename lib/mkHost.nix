inputs: hostname: username: system:
inputs.nixpkgs.lib.nixosSystem {
  inherit system;
  specialArgs = { inherit inputs; }; # Pass flake variable
  modules = [
    {
      nixpkgs.pkgs = inputs.self.pkgs;
      networking.hostName = hostname;

      nixpkgs.overlays = [ inputs.emacs-overlay.overlay ]; # REVIEW: idk where
    }
    # general settings applicable to all hosts
    "${inputs.self}/hosts/nixos-defaults.nix"
    "${inputs.self}/hosts/home-defaults.nix"

    (import "${inputs.self}/hosts/${hostname}")

    inputs.home-manager.nixosModules.home-manager
    inputs.hyprland.nixosModules.default
  ]
  # Import all personal modules to every host
  ++ builtins.attrValues inputs.self.nixosModules;
}
