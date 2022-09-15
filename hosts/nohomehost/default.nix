# Specific system configuration settings

{ config, inputs, pkgs, lib, ... }:

{
	imports = [
		../home.nix
		./hardware-configuration.nix
	];

	## Modules
	modules = {
		flakes.enable = true;
		desktop = {
			hyprland.enable = true;
			# rofi.enable = true;
			browsers = {
				default = "qutebrowser";
				# firefox.enable = true; # TODO: setup maybe?
				qutebrowser.enable = true;
			};
			steam.enable = true;
			term.alacritty.enable = true; # TODO: try out st (have config pre-ready)
			# vm = {
			# 	qemu.enable = true;
			# };
		};
		dev.node.enable = true;
		editors = {
			default = "emacs"; # nvim
			emacs.enable = true;
			emacs.doom.enable = true;
			# vim.enable = true;
		};
		shell = {
			# adl.enable = true;
			# vaultwarden.enable = true; # lightweigt client for bitwarden
		 	git.enable   = true;
			gnupg.enable = true;
			pass.enable  = true;
			zsh.enable   = true;
		};
		services = {
			ssh.enable = true;
			syncthing.enable = true;

		};
		# theme.active = "alucard";
	};

	# packages that do not requrie any additional configuration
	# which i can enable / disable just by commenting those out
	user.packages = with pkgs; [
		# Shell script programmers are strange beasts. Writing programs in a language
		# that wasn't intended as a programming language. Alas, it is not for us mere
		# mortals to question the will of the ancient ones. If they want shell programs,
		# they get shell programs.
		shellcheck

		inputs.webcord.packages.${pkgs.system}.default

		# mpv
		mpv-with-scripts
		mpvc  # CLI controller for mpv

		font-manager   # so many damned fonts...
		# imagemagick    # for image manipulation from the shell

		# common lisp
		# sbcl
		# lispPackages.quicklisp

		lua

	];

	## Local config
	services.openssh.startWhenNeeded = true;

	networking.networkmanager = {
		enable = true;
		# dns = "systemd-resolved"; # REVIEW
	};
  # networking.wireless.enable = true;

  time.timeZone = "Europe/Moscow";
}
