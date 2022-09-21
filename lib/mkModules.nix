/*
mkModules: creates and attrSet from a folder The folder may contain .nix
files or folders with default.nix, which in turn contain lambdas (such as nixos
modules or overlays).

As such, the result of running it on this repo:

nix-repl> :lf
nix-repl> mkModules ./modules/nixos
{
  channels-to-flakes = «lambda @ ... »;
  common = «lambda @ ... »;
  # ...
}
*/
inputs: dir:
let inherit (inputs.nixpkgs) lib; in
lib.listToAttrs (map
  # mapper function
  (arg: {
    name = lib.removeSuffix ".nix" (baseNameOf arg);
    value = import arg;
  })
  # value
  (lib.mapAttrsToList (name: _: dir + "/${name}") (builtins.readDir dir))
)
