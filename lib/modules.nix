inputs:
let
  inherit (builtins) attrValues readDir pathExists concatLists;
  inherit (inputs.nixpkgs.lib) listToAttrs id mapAttrsToList filterAttrs hasPrefix hasSuffix nameValuePair removeSuffix;

  # mapFilterAttrs ::
  #   (name -> value -> bool)
  #   (name -> value -> { name = any; value = any; })
  #   attrs
  mapFilterAttrs = pred: f: attrs:
    filterAttrs pred (inputs.nixpkgs.lib.mapAttrs' f attrs);
in
rec {
  mapModules = dir: fn:
    mapFilterAttrs
      (n: v: v != null && !(hasPrefix "_" n))
      (n: v:
        let path = "${toString dir}/${n}"; in

        if v == "directory" && pathExists "${path}/default.nix"
        then nameValuePair n (fn path)

        else if v == "regular" && n != "default.nix" && hasSuffix ".nix" n
        then nameValuePair (removeSuffix ".nix" n) (fn path)
        else nameValuePair "" null)
      (readDir dir);

  /*
  exportModulesDir: creates and attrSet from a folder The folder may contain
  .nix files or folders with default.nix, which in turn contain lambdas (such as
  nixos modules or overlays).

  As such, the result of running it on this repo:

  nix-repl> :lf
  nix-repl> exportModulesDir ./modules/nixos
  {
    channels-to-flakes = «lambda @ ... »;
    common = «lambda @ ... »;
    # ...
  }
  */
  exportModulesDir = dir:
    listToAttrs (map
      # mapper function
      (arg: {
        name = removeSuffix ".nix" (baseNameOf arg);
        value = import arg;
      })
      # values
      (mapAttrsToList (name: _: dir + "/${name}") (readDir dir))
    );

  exportModulesDir' = dir:
    map import (mapAttrsToList (name: _: dir + "/${name}") (readDir dir));

  mapModulesRec' = dir: fn:
    let
      dirs =
        mapAttrsToList
          (k: _: "${dir}/${k}")
          (filterAttrs (n: v: v == "directory") (readDir dir));
      files = attrValues (mapModules dir id);
      paths = files ++ concatLists (map (d: mapModulesRec' d id) dirs);
    in map fn paths;
}
