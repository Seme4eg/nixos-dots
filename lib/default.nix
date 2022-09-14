inputs:
# TODO: func below returns a set with wrong format with my purpose
# {name: .., value: ..}, and i need it just to be a set of functions / vars
# write a function that will free me from listing all modules manually

# let inherit (import ./modules.nix inputs) mapModules;
# in mapModules ./. (file: import file inputs)

let
  attrs = import ./attrs.nix inputs;
  modules = import ./modules.nix inputs;
  nixos = import ./nixos.nix inputs;
  options = import ./options.nix inputs;
in
attrs // modules // nixos // options # // lib ?
