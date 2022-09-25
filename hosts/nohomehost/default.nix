# Specific system configuration settings

{ config, inputs, pkgs, lib, ... }:

{
	imports = [
		./hardware-configuration.nix
		./home-configuration.nix
	];

	## Modules
	modules = {
		flakes.enable = true;
		desktop.gaming.enable = true;
		wayland.enable = true;
		shell = {
			# adl.enable = true;
			# vaultwarden.enable = true; # lightweigt client for bitwarden
			gnupg.enable = true;
			pass.enable  = true;
			zsh.enable   = true; # XXX: remove it when yall wana fuc ur brein
		};
		services = {
			ssh.enable = true;
			syncthing.enable = true;
			openvpn.enable = false;
		};
		# theme.active = "alucard";
	};

	# packages that do not requrie any additional configuration
	# which i can enable / disable just by commenting those out
	user = {
		# Define a user account. Don't forget to set a password with ‘passwd’.
		extraGroups = [ "wheel" ]; # adbusers?
		isNormalUser = true;
		home = "/home/nohome"; # TODO: remove it
		shell = pkgs.zsh;
	};

	## Local config
	services.openssh.startWhenNeeded = true;

	# REVIEW: for emacs only, maybe move somewhere else
	fonts.fonts = [ pkgs.emacs-all-the-icons-fonts ];
	services.locate = {
		locate = pkgs.plocate;
		enable = true;
		interval = "hourly";
		localuser = null;
	};
	# --- end

	# gnupg setup
	# environment.variables.GNUPGHOME = "$XDG_CONFIG_HOME/gnupg";
	# programs.gnupg.agent.enable = true;
	# agent.enableSSHSupport = true;

	networking.networkmanager = {
		enable = true;
		# dns = "systemd-resolved"; # REVIEW
	};
  # networking.wireless.enable = true;

	time.timeZone = lib.mkDefault "Europe/Moscow";
	i18n.defaultLocale = lib.mkDefault "en_US.UTF-8";
	location = (if config.time.timeZone == "Europe/Moscow" then {
		latitude = 55.7;
		longitude = 37.6;
	} else {});
}
