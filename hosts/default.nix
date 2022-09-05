# General settings applicable to all hosts

# these are passed from flake.nix
{ inputs, config, lib, pkgs, ... }:

with lib;
with lib.my;
{
	imports = [
		# I use home-manager to deploy files to $HOME; little else
			inputs.home-manager.nixosModules.home-manager
			inputs.hyprland.nixosModules.default
		]
		# Import all personal modules to every host
		++ (mapModulesRec' (toString ../modules) import);

	# Common config for all nixos machines; and to ensure the flake operates
	# soundly
	environment.variables.DOTFILES = config.dotfiles.dir;
	environment.variables.DOTFILES_BIN = config.dotfiles.binDir;

	# Configure nix and nixpkgs
	environment.variables.NIXPKGS_ALLOW_UNFREE = "1";
	nix =
		let filteredInputs = filterAttrs (n: _: n != "self") inputs;
				nixPathInputs  = mapAttrsToList (n: v: "${n}=${v}") filteredInputs;
				registryInputs = mapAttrs (_: v: { flake = v; }) filteredInputs;
		in {
			package = pkgs.nixFlakes; # enable nixFlakes on system

			extraOptions = "experimental-features = nix-command flakes";
			# keep-outputs = true
			# keep-derivations = true

			# REVIEW: what brakes if i remove it?
			nixPath = nixPathInputs ++ [
				"nixpkgs-overlays=${config.dotfiles.dir}/overlays"
				"dotfiles=${config.dotfiles.dir}"
			];
			# and that
			# registry.nixpkgs.flake = inputs.nixpkgs;
			registry = registryInputs // { dotfiles.flake = inputs.self; };

			# Another example of setting registry
			# registry = {
			#   self.flake = self;
			#   emerge.to = {
			#     type = "git";
			#     url = "file://${toString var.path.entry}";
			#   };
			# };


			settings = {
				substituters = [
					"https://nix-community.cachix.org"
					"https://webcord.cachix.org"
					# "http://cache.nixos.org" # Default
				];
				trusted-public-keys = [
					"nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
					"webcord.cachix.org-1:l555jqOZGHd2C9+vS8ccdh8FhqnGe8L78QrHNn+EFEs="
				];
				auto-optimise-store = true; # optimize syslinks
			};

			# garbage collector setup
			gc = {
				automatic = true;
				dates = "weekly";
				options = "--delete-older-than 7d";
			};
		};

	# REVIEW: why would i want that?
	# system.configurationRevision = with inputs; mkIf (self ? rev) self.rev;

	system = {
		stateVersion = "21.05";
		# REVIEW: ppl don't use it, why?
		# autoUpgrade = {
			# enable = true;
			# channel = "https://nixos.org/channels/nixos-unstable";
		# };
	};

	## Some reasonable, global defaults
	# This is here to appease 'nix flake check' for generic hosts with no
	# hardware-configuration.nix or fileSystem config.
	#fileSystems."/".device = mkDefault "/dev/disk/by-label/nixos";

	# The global useDHCP flag is deprecated, therefore explicitly set to false
	# here. Per-interface useDHCP will be mandatory in the future, so we enforce
	# this default behavior here.
	networking.useDHCP = mkDefault false;

	# Use the latest kernel
	boot = {
		# kernelPackages = mkDefault pkgs.linuxKernel.packages.linux_5_18;
		kernelPackages = mkDefault pkgs.linuxPackages_latest; # latest linux kernel
		loader = {
			efi.canTouchEfiVariables = mkDefault true;
			systemd-boot.configurationLimit = 5;
			systemd-boot.enable = mkDefault true;
			timeout = 3; # works for grub and efi boot
		};
	};

	# ----------- SORT TRASH BELOW -----------------

	# Select internationalisation properties.
	console = {
		#font = "Lat2-Terminus16";
		# keyMap = "us";
		useXkbConfig = true; # use xkbOptions in tty.
		# Enable setting virtual console options as early as possible (in initrd).
		earlySetup = true;
	};

	# ---------------- END OF TRASH ------------------

	# Just the bear necessities...
	environment.systemPackages = with pkgs; [
		# bind
		cached-nix-shell
		git
		vim
		wget
		# gnumake
		unzip
	];
}
