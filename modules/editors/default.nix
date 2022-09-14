{ config, options, lib, inputs, ... }:

let cfg = config.modules.editors;
    inherit (inputs.self.lib) mkOpt;
in {
  options.modules.editors = {
    default = mkOpt lib.types.str "vim";
  };

  config = lib.mkIf (cfg.default != null) {
    env.EDITOR = cfg.default;
  };
}
