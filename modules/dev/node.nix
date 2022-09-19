# modules/dev/node.nix --- https://nodejs.org/en/
#
# JS is one of those "when it's good, it's alright, when it's bad, it's a
# disaster" languages.

{ config, options, lib, pkgs, ... }:

let devCfg = config.modules.dev;
    cfg = devCfg.node;
in {
  options.modules.dev.node.enable = lib.mkEnableOption "node";

  config =
    let node = pkgs.nodejs_latest;
    in lib.mkIf cfg.enable {
      user.packages = [
        node
        pkgs.yarn
      ];

      # Run locally installed bin-script, e.g. n coffee file.coffee
      environment.shellAliases = {
        n  = "PATH=\"$(${node}/bin/npm bin):$PATH\"";
        ya = "yarn";
      };

      environment.variables.PATH = [ "$(${pkgs.yarn}/bin/yarn global bin)" ];

      # XDG settings
      environment.variables.NPM_CONFIG_USERCONFIG = "$XDG_CONFIG_HOME/npm/config";
      environment.variables.NPM_CONFIG_CACHE      = "$XDG_CACHE_HOME/npm";
      environment.variables.NPM_CONFIG_TMP        = "$XDG_RUNTIME_DIR/npm";
      environment.variables.NPM_CONFIG_PREFIX     = "$XDG_CACHE_HOME/npm";
      environment.variables.NODE_REPL_HISTORY     = "$XDG_CACHE_HOME/node/repl_history";

      home.configFile."npm/config".text = ''
        cache=$XDG_CACHE_HOME/npm
        prefix=$XDG_DATA_HOME/npm
      '';
    };
}
