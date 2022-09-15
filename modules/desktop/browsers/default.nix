{ options, config, lib, inputs, ... }:

let cfg = config.modules.desktop.browsers;
in {
  options.modules.desktop.browsers = {
    default = lib.mkOption {
      type = (with lib.types; nullOr str);
      default = null;
    };
  };

  config = lib.mkIf (cfg.default != null) {
    env.BROWSER = cfg.default;
  };
}
