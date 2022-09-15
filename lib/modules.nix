inputs:
let
  inherit (builtins) attrValues readDir pathExists concatLists;
  inherit (inputs.nixpkgs.lib) id mapAttrsToList filterAttrs hasPrefix hasSuffix nameValuePair removeSuffix;

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

  mapModulesRec = dir: fn:
    mapFilterAttrs
      (n: v: v != null && !(hasPrefix "_" n))
      (n: v:
        let path = "${toString dir}/${n}"; in

        if v == "directory"
        then nameValuePair n (mapModulesRec path fn)

        else if v == "regular" && n != "default.nix" && hasSuffix ".nix" n
        then nameValuePair (removeSuffix ".nix" n) (fn path)
        else nameValuePair "" null)
      (readDir dir);

  mapModulesRec' = dir: fn:
    let
      dirs =
        mapAttrsToList
          (k: _: "${dir}/${k}")
          (filterAttrs
            (n: v: v == "directory" && !(hasPrefix "_" n))
            (readDir dir));
      files = attrValues (mapModules dir id);
      paths = files ++ concatLists (map (d: mapModulesRec' d id) dirs);
    in map fn paths;
}
