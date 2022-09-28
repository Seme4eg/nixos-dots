# General home-manaer configuratoin. It gets imported in each host

{ inputs, options, config, lib, pkgs, ... }:
let homeModules = inputs.self.lib.mkModules ../modules/home; in
{
	# Install user packages to /etc/profiles instead. Necessary for
	# nixos-rebuild build-vm to work.
	home-manager = {
		useGlobalPkgs = true;
		useUserPackages = true;
		extraSpecialArgs = {inherit inputs;}; # Pass flake variable

		users.${config.username} = {
			# import all modules by default for all users
			imports = [
				inputs.hyprland.homeManagerModules.default
			] ++ builtins.attrValues homeModules;

			programs.home-manager.enable = true;

			# Necessary for home-manager to work with flakes, otherwise it will
			# look for a nixpkgs channel.
			home = {
				username = "${config.username}";
				homeDirectory = "/home/${config.username}";
				stateVersion = config.system.stateVersion;
			};
		};
	};
}
