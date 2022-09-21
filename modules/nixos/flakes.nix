{config, pkgs, lib, inputs, ...}: let
  nixpkgsPath = "/etc/nixpkgs/channels/nixpkgs";
  cfg = config.modules.flakes;
in {
  options.modules.flakes.enable = lib.mkEnableOption "flakes";

  config = lib.mkIf cfg.enable {
    nix = {
      package = pkgs.nixUnstable;
      settings.experimental-features = "nix-command flakes"; # ? [ "nix-command" "flakes" ];

      registry.nixpkgs.flake = inputs.nixpkgs;

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
      nixPath = [
        # List of directories to be searched for <...> file references.
        "nixpkgs=${nixpkgsPath}"
        "/nix/var/nix/profiles/per-user/root/channels"
      ];
    };

    systemd.tmpfiles.rules = [
      "L+ ${nixpkgsPath} - - - - ${inputs.nixpkgs}"
    ];
  };
}
