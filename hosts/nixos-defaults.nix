# General settings applicable to all hosts

{ inputs, config, lib, pkgs, ... }:
let
  inherit (lib) mkDefault mapAttrs;
  nixpkgsPath = "/etc/nixpkgs-channel";
in {
  # Common config for all nixos machines; and to ensure the flake operates
  # soundly
  environment = {
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

    # Make angle bracket references (e.g. nix repl '<nixpkgs>') use my flake's
    # nixpkgs, instead of whatever the imperatively managed version is. One day
    # flakes will completely kill off channels... one day.
    #
    # NOTE: My bash or zsh profiles don't seem to use NixOS's command-not-found
    # handler, but if that ever changes then keep in mind that removing the root
    # channel may cause breakage. See the discourse link below.
    #
    # https://discourse.nixos.org/t/do-flakes-also-set-the-system-channel/19798/2
    # https://github.com/NobbZ/nixos-config/blob/main/nixos/modules/flake.nix
    nixPath = [ "nixpkgs=${nixpkgsPath}" ];

    # Make registry-based commands (e.g. nix run nixpkgs#foo) use my flake's
    # system nixpkgs, instead of looking up the latest nixpkgs revision from
    # GitHub.
    registry.nixpkgs.flake = inputs.nixpkgs;
    # registry = lib.mapAttrs (_: v: { flake = v; }) inputs;

    # Settings is for nix.conf. See man nix.conf.
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
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
      allow-import-from-derivation = true; # true cuz of 'nur'
      builders-use-substitutes = true;
      warn-dirty = false;
    };

    # Automatically hardlink identical files.
    optimise.automatic = true;

    # garbage collector setup
    gc = {
      automatic = true;
      options = "--delete-older-than 7d";
    };
  };

  system = {
    # The Git revision of the top-level flake from which this configuration was
    # built.
    configurationRevision = inputs.self.rev or "dirty";
    stateVersion = "21.05";
  };

  systemd.tmpfiles.rules = [
    # Static symlink for nix.nixPath, which controls $NIX_PATH. Using nixpkgs input directly would
    # result in $NIX_PATH containing a /nix/store value, which would be inaccurate after the first
    # nixos-rebuild switch until logging out (and prone to garbage collection induced breakage).
    "L+ ${nixpkgsPath} - - - - ${inputs.nixpkgs}"
  ];

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
