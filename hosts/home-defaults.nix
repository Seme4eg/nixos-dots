# General home-manaer configuratoin. It gets imported in each host

{ inputs, options, config, lib, pkgs, ... }: {
	# Install user packages to /etc/profiles instead. Necessary for
	# nixos-rebuild build-vm to work.
	home-manager = {
		useGlobalPkgs = true;
		useUserPackages = true;

		# I only need a subset of home-manager's capabilities. That is, access to
		# its home.file, home.xdg.configFile and home.xdg.dataFile so I can deploy
		# files easily to my $HOME, but 'home-manager.users.<user>.home.file.*'
		# is much too long and harder to maintain, so I've made aliases in:
		#
		#   home.file        ->  home-manager.users.<user>.home.file
		#   home.configFile  ->  home-manager.users.<user>.home.xdg.configFile
		#   home.dataFile    ->  home-manager.users.<user>.home.xdg.dataFile
		users.${config.username} = {
			home = {
				file = lib.mkAliasDefinitions options.home.file;
				# Necessary for home-manager to work with flakes, otherwise it will
				# look for a nixpkgs channel.
				stateVersion = config.system.stateVersion;
			};
			xdg = {
				configFile = lib.mkAliasDefinitions options.home.configFile;
				dataFile   = lib.mkAliasDefinitions options.home.dataFile;
			};
		};
	};
}
