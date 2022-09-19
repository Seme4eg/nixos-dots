# modules/agenix.nix -- encrypt secrets in nix store

{ config, inputs, lib, ... }:

with builtins;
let inherit (inputs) agenix;
    # secretsDir = "${toString ../hosts}/${config.networking.hostName}/secrets";
    secretsDir = "${inputs.self}/secrets";
    secretsFile = "${secretsDir}/secrets.nix";
in {
  imports = [ agenix.nixosModules.age ];
  environment.systemPackages = [ agenix.defaultPackage.x86_64-linux ];

  age = {
    secrets =
      if pathExists secretsFile
      then lib.mapAttrs' (n: _: lib.nameValuePair (lib.removeSuffix ".age" n) {
        file = "${secretsDir}/${n}";
        owner = lib.mkDefault config.username;
      }) (import secretsFile)
      else {};
    identityPaths = [ "/home/${config.username}/.ssh/id_ed25519" ];
      # options.age.identityPaths.default ++ (filter pathExists [
      #   "${config.user.home}/.ssh/id_ed25519"
      #   "${config.user.home}/.ssh/id_rsa"
      # ]);
  };
}
