# Specific system configuration settings

{ config, pkgs, lib, ... }:

{
	imports = [
		../home.nix
		./hardware-configuration.nix
	];

	## Modules
	modules = {
		desktop = {
			hyprland.enable = true;
			# rofi.enable = true;
			browsers = {
				default = "qutebrowser";
				# firefox.enable = true; # XXX
				qutebrowser.enable = true;
			};
			steam.enable = true;
			webcord.enable = true;
			graphics.enable = true; # REVIEW: not sure about naming
			mpv.enable = true;
			term = {
				default = "alacritty"; # xst
				alacritty.enable = true;
				# st.enable = true;
			};
			# vm = {
			# 	qemu.enable = true;
			# };
		};
		dev = {
			lua.enable = true;
			node.enable = true;
			# shell.enable = true;
			# common-lisp.enable = true;
		};
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

			# TODO:
			# wireguard.enable = true; # migrate from openvpn to wireguard
			# transmission.enable = true; # bittorrent client - https://transmissionbt.com/

			# maybe i'll need those some day
			# discourse.enable = true;
			# jellyfin.enable = true;
		};
		# theme.active = "alucard";
	};

	## Local config
	services.openssh.startWhenNeeded = true;

	networking.networkmanager = {
		enable = true;
		# dns = "systemd-resolved"; # REVIEW
	};
  # networking.wireless.enable = true;

  time.timeZone = "Europe/Moscow";
}
