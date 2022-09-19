{ config, options, lib, inputs, ... }:

let cfg = config.modules.editors;
in {
  options.modules.editors = {
    default = lib.mkOption { type = lib.types.str; default = "vim"; };
  };

  config = lib.mkIf (cfg.default != null) {
    environment.variables.EDITOR = cfg.default;
  };
}
