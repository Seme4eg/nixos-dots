{ options, config, lib, inputs, ... }:

let cfg = config.modules.desktop.browsers;
    inherit (inputs.self.lib) mkOpt;
in {
  options.modules.desktop.browsers = {
    default = mkOpt (with lib.types; nullOr str) null;
  };

  config = lib.mkIf (cfg.default != null) {
    env.BROWSER = cfg.default;
  };
}
