# Specific system configuration settings

{ config, inputs, pkgs, lib, ... }:

{
  imports = [ ./hardware-configuration.nix ./home-configuration.nix ];

  ## Modules
  modules = {
    desktop.gaming.enable = true;
    wayland.enable = true;
    emacs.enable = true;
    services = {
      ssh.enable = true;
      syncthing.enable = true;
      # openvpn.enable = false;
    };
    # theme.active = "alucard";
  };

  user = {
    # Define a user account. Don't forget to set a password with ‘passwd’.
    extraGroups = [ "wheel" ]; # adbusers?
    isNormalUser = true;
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

  systemd.tmpfiles.rules = [
    # Static symlink for nix.nixPath, which controls $NIX_PATH. Using nixpkgs
    # input directly would result in $NIX_PATH containing a /nix/store value,
    # which would be inaccurate after the first nixos-rebuild switch until
    # logging out (and prone to garbage collection induced breakage).
    "L+ /usr/local/tdlib - - - - ${pkgs.tdlib}"
  ];
  # --- end

  # gnupg setup
  # environment.variables.GNUPGHOME = "$HOME/.config/gnupg";
  # programs.gnupg.agent.enable = true;
  # agent.enableSSHSupport = true;

  networking.networkmanager = {
    enable = true;
    # dns = "systemd-resolved"; # "default"
  };
  # networking.wireless.enable = true;

  # enable zsh autocompletion for system packages (systemd, etc)
  environment.pathsToLink = [ "/share/zsh" ];

  time.timeZone = lib.mkDefault "Europe/Moscow";
  i18n.defaultLocale = lib.mkDefault "en_US.UTF-8";
  location = (if config.time.timeZone == "Europe/Moscow" then {
    latitude = 55.7;
    longitude = 37.6;
  } else
    { });
}
