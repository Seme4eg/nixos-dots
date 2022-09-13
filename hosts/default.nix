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

	# Settings is for nix.conf. See man nix.conf.
	nix =
		let filteredInputs = filterAttrs (n: _: n != "self") inputs;
				nixPathInputs  = mapAttrsToList (n: v: "${n}=${v}") filteredInputs;
				registryInputs = mapAttrs (_: v: { flake = v; }) filteredInputs;
		in {
			package = pkgs.nixUnstable; # or nixFlakes ?

      # for direnv GC roots add these lines in options below
      # keep-outputs = true
      # keep-derivations = true

			extraOptions = ''
				builders-use-substitutes = true
				experimental-features = nix-command flakes
			'';

				# flake-registry = /etc/nix/registry.json

      # Make angle bracket references (e.g. nix repl '<nixpkgs>') use my flake's
      # nixpkgs, instead of whatever the imperatively managed version is. One
      # day flakes will completely kill off channels... one day.
      #
      # NOTE: My bash or zsh profiles don't seem to use NixOS's
      # command-not-found handler, but if that ever changes then keep in mind
      # that removing the root channel may cause breakage. See the discourse
      # link below.
      #
      # https://discourse.nixos.org/t/do-flakes-also-set-the-system-channel/19798/2
      # https://github.com/NobbZ/nixos-config/blob/main/nixos/modules/flake.nix
			nixPath = nixPathInputs ++ [
				"nixpkgs-overlays=${config.dotfiles.dir}/overlays"
				"dotfiles=${config.dotfiles.dir}"
			]; # nixPath = [ "nixpkgs=${nixpkgsPath}" ];

      # Make registry-based commands (e.g. nix run nixpkgs#foo) use my flake's
      # system nixpkgs, instead of looking up the latest nixpkgs revision from
      # GitHub.
			registry = registryInputs // { dotfiles.flake = inputs.self; };
			# registry.nixpkgs.flake = inputs.nixpkgs;

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

        # allow-import-from-derivation = false; # REVIEW
        experimental-features = [ "nix-command" "flakes" ];
        # I know how to use git without nagging, thank you very much.
        warn-dirty = false;
			};

      # Automatically hardlink identical files.
      optimise.automatic = true;

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
