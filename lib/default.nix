inputs: {
  # functions
  mkHost = import ./mkHost.nix inputs;
  mkModules = import ./mkModules.nix inputs;
} # // (import ./some-module.nix inputs) # <- add sets this way
