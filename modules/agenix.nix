# modules/agenix.nix -- encrypt secrets in nix store

{ options, config, inputs, lib, pkgs, ... }:

with builtins;
with lib;
with lib.my;
let inherit (inputs) agenix;
    # secretsDir = "${toString ../hosts}/${config.networking.hostName}/secrets";
    secretsDir = "${config.dotfiles.dir}/secrets";
    secretsFile = "${secretsDir}/secrets.nix";
in {
  imports = [ agenix.nixosModules.age ];
  environment.systemPackages = [ agenix.defaultPackage.x86_64-linux ];

  age = {
    secrets =
      if pathExists secretsFile
      then mapAttrs' (n: _: nameValuePair (removeSuffix ".age" n) {
        file = "${secretsDir}/${n}";
        owner = mkDefault config.user.name;
      }) (import secretsFile)
      else {};
    identityPaths = [ "${config.user.home}/.ssh/id_ed25519" ];
      # options.age.identityPaths.default ++ (filter pathExists [
      #   "${config.user.home}/.ssh/id_ed25519"
      #   "${config.user.home}/.ssh/id_rsa"
      # ]);
  };
}
