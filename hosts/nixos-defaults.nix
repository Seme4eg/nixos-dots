# General settings applicable to all hosts

{ inputs, config, lib, pkgs, ... }:
let inherit (lib) mkDefault mapAttrs;
in {
  # Common config for all nixos machines; and to ensure the flake operates
  # soundly
  environment = {
    etc = {
      "nix/flake-channels/system".source = inputs.self;
      "nix/flake-channels/nixpkgs".source = inputs.nixpkgs;
      "nix/flake-channels/home-manager".source = inputs.home-manager;
    };

    # Just the bear necessities...
    systemPackages = with pkgs; [
      # bind
      cached-nix-shell
      git
      wget
      # gnumake
      unzip
      sqlite
    ];

  };

  # Settings for nix.conf. See man nix.conf.
  nix = let users = [ "root" config.username ];
  in {
    package = pkgs.nixUnstable;
    settings.experimental-features =
      "nix-command flakes"; # ? [ "nix-command" "flakes" ];

    nixPath = [
      # List of directories to be searched for <...> file references.
      "nixpkgs=/etc/nix/flake-channels/nixpkgs"
      "home-manager=/etc/nix/flake-channels/home-manager"
    ];
    registry = lib.mapAttrs (_: v: { flake = v; }) inputs;

    settings = {
      substituters = [
        "https://nix-community.cachix.org"
        "https://webcord.cachix.org"
        "http://cache.nixos.org" # Default
      ];
      trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "webcord.cachix.org-1:l555jqOZGHd2C9+vS8ccdh8FhqnGe8L78QrHNn+EFEs="
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      ];
      auto-optimise-store = true; # optimize syslinks

      # ensure that my evaluation will not require any builds to take place.
      allow-import-from-derivation = true;
      builders-use-substitutes = true;
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

  system = {
    # The Git revision of the top-level flake from which this configuration was
    # built.
    configurationRevision = inputs.self.rev or "dirty";
    stateVersion = "21.05";
  };

  # The global useDHCP flag is deprecated, therefore explicitly set to false
  # here. Per-interface useDHCP will be mandatory in the future, so we enforce
  # this default behavior here.
  networking.useDHCP = mkDefault false;

  boot = {
    kernelPackages = mkDefault pkgs.linuxPackages_latest; # latest linux kernel
    loader = {
      efi.canTouchEfiVariables = mkDefault true;
      systemd-boot.configurationLimit = 5;
      systemd-boot.enable = mkDefault true;
      timeout = 3; # works for grub and efi boot
    };
  };

  # REVIEW: prob this 'console' object doesn't belong here
  # Select internationalisation properties.
  console = {
    #font = "Lat2-Terminus16";
    # keyMap = "us";
    useXkbConfig = true; # use xkbOptions in tty.
    # Enable setting virtual console options as early as possible (in initrd).
    earlySetup = true;
  };

}
