{ options, config, lib, inputs, ... }:

let cfg = config.modules.desktop.term;
    inherit (inputs.self.lib) mkOpt;
in {
  options.modules.desktop.term = {
    default = mkOpt lib.types.str "xterm";
  };

  config = {
    services.xserver.desktopManager.xterm.enable = lib.mkDefault (cfg.default == "xterm");

    env.TERMINAL = cfg.default;
  };
}
