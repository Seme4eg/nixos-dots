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

			settings = {
				# Default - https://cache.nixos.org/
				substituters = ["https://nix-community.cachix.org"];
				trusted-public-keys = [
					"nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
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
		autoUpgrade = {
			# enable = true;
			# channel = "https://nixos.org/channels/nixos-unstable";
		};
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
			systemd-boot.configurationLimit = 10;
			systemd-boot.enable = mkDefault true;
			timeout = 3; # works for grub and efi boot
		};

		# Use the systemd-boot EFI boot loader.
		loader = {
			# XXX: check grub options, there are plenty - themes, maybe jus disable it at all? so it's skipped
			# below doesn't work, using systemd instead in /hosts/default.nix
			# grub = {
			# 	version = 2;
			# 	configurationLimit = 3; # limit stored? (or showed?) system configurations
			# };
		};
	};

	# ----------- SORT TRASH BELOW -----------------

	# Select internationalisation properties.
	console = {
		#font = "Lat2-Terminus16";
		# keyMap = "us";
		useXkbConfig = true; # use xkbOptions in tty.
	};

	# Icons MS Nerdfont Icons override
	fonts.fonts = with pkgs; [
		source-code-pro
		font-awesome
		corefonts
		(nerdfonts.override {
			fonts = [
				"FiraCode"
			];
		})
	];

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
