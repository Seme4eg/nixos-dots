{ inputs, lib, pkgs, ... }:

let
  inherit (lib) makeExtensible attrValues foldr;
  inherit (import ./modules.nix {inherit lib;}) mapModules;

  mylib = makeExtensible (self:
    with self; mapModules ./.
      (file: import file { inherit self lib pkgs inputs; }));
in
mylib.extend
  (self: super:
    foldr (a: b: a // b) {} (attrValues super))

# TODO: func below returns a set with wrong format with my purpose
# {name: .., value: ..}, and i need it just to be a set of functions / vars
# write a function that will free me from listing all modules manually

# let
#   inherit (import ./modules.nix inputs) mapModules;
# in mapModules ./. (file: import file { inherit lib pkgs inputs; })
