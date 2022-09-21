inputs: name: system:
inputs.nixpkgs.lib.nixosSystem {
  inherit system;
  specialArgs = { inherit inputs; }; # XXX: remove this line
  modules = [
    {
      nixpkgs.pkgs = inputs.self.pkgs;
      networking.hostName = name;
    }
    # file with general settings applicable to all hosts
    "${inputs.self}/hosts/default-settings.nix"
    (import "${inputs.self}/hosts/${name}")

    inputs.home-manager.nixosModules.default # XXX: remove
    inputs.hyprland.nixosModules.default
  ]
  # Import all personal modules to every host
  ++ builtins.attrValues inputs.self.nixosModules;
}
