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
			imports = builtins.attrValues homeModules;

			# REVIEW: is that necessary?
			programs = {
				home-manager.enable = true;
			};

			# XXX: remove it
			#   home.file        ->  home-manager.users.<user>.home.file
			#   home.configFile  ->  home-manager.users.<user>.home.xdg.configFile
			home = {
				file = lib.mkAliasDefinitions options.home.file;
				# Necessary for home-manager to work with flakes, otherwise it will
				# look for a nixpkgs channel.
				stateVersion = config.system.stateVersion;
			};
			xdg.configFile = lib.mkAliasDefinitions options.home.configFile;
		};
	};
}
