inputs:
let inherit (inputs.nixpkgs.lib) mkOption types;
in rec {
  mkOpt  = type: default:
    mkOption { inherit type default; };

  mkOpt' = type: default: description:
    mkOption { inherit type default description; };
}
