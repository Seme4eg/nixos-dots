inputs: hostname: username: system:
inputs.nixpkgs.lib.nixosSystem {
  inherit system;
  specialArgs = { inherit inputs; }; # Pass flake variable
  modules = [
    {
      nixpkgs.pkgs = inputs.self.pkgs;
      networking.hostName = hostname;

      nixpkgs.overlays = [
        inputs.emacs-overlay.overlay

        # NOTE: Waybar version, which allows for wlr/workspaces module
        (final: prev: {
          waybar = inputs.hyprland.packages.${final.system}.waybar-hyprland;
          # Another way of doing the above:
          # waybar = super.waybar.overrideAttrs (oldAttrs: {
          #   mesonFlags = oldAttrs.mesonFlags ++ [ "-Dexperimental=true" ];
          # });
        })
      ];
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
