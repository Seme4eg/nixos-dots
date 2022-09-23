# General home-manaer configuratoin. It gets imported in each host

{ inputs, options, config, lib, pkgs, ... }: {
	# Install user packages to /etc/profiles instead. Necessary for
	# nixos-rebuild build-vm to work.
	home-manager = {
		useGlobalPkgs = true;
		useUserPackages = true;

		extraSpecialArgs = {inherit inputs;};

		# XXX: remove it
		#   home.file        ->  home-manager.users.<user>.home.file
		#   home.configFile  ->  home-manager.users.<user>.home.xdg.configFile
		users.${config.username} = {
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
