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
		# 	apps = {
		# 		rofi.enable = true;
		# 		# godot.enable = true;
		# 	};
			browsers = {
				default = "qutebrowser";
				# firefox.enable = true; # XXX
				qutebrowser.enable = true;
			};
		};
		# desktop = {
		# 	gaming = {
		# 		steam.enable = true;
		# 		# emulators.enable = true;
		# 		# emulators.psx.enable = true;
		# 	};
		# 	media = {
		# 		daw.enable = true;
		# 		documents.enable = true;
		# 		graphics.enable = true;
		# 		mpv.enable = true;
		# 		recording.enable = true;
		# 		spotify.enable = true;
		# 	};
		# 	term = {
		# 		default = "xst";
		# 		st.enable = true;
		# 	};
		# 	vm = {
		# 		qemu.enable = true;
		# 	};
		# };
		# dev = {
		# 	node.enable = true;
		# 	rust.enable = true;
		# 	python.enable = true;
		# };
		editors = {
			default = "emacs"; # nvim
			emacs.enable = true;
			emacs.doom.enable = true;
			# vim.enable = true;
		};
		shell = {
		# 	adl.enable = true;
		# 	vaultwarden.enable = true;
		# 	direnv.enable = true;
		 	git.enable    = true;
		# 	gnupg.enable  = true;
		# 	tmux.enable   = true;
			zsh.enable    = true;
		};
		services = {
			ssh.enable = true;
			# docker.enable = true;
			# Needed occasionally to help the parental units with PC problems
			# teamviewer.enable = true;
		};
		# theme.active = "alucard";
	};

	## Local config
	programs.ssh.startAgent = true;
	services.openssh.startWhenNeeded = true;

	networking.networkmanager.enable = true;

}
