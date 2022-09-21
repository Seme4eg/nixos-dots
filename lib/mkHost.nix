inputs: name:
inputs.nixpkgs.lib.nixosSystem {
  system = "x86_64-linux";
  specialArgs = { inherit inputs; }; # XXX: remove this line
  modules = [
    {
      nixpkgs.pkgs = inputs.self.pkgs;
      networking.hostName = name;
    }
    # file with general settings applicable to all hosts
    ../hosts/default-settings.nix
    (import "${inputs.self}/hosts/${name}")

    inputs.home-manager.nixosModules.default # XXX: remove
    inputs.hyprland.nixosModules.default
  ]
  # Import all personal modules to every host
  ++ builtins.attrValues inputs.self.nixosModules;
}
