# https://nodejs.org/en/
#
# JS is one of those "when it's good, it's alright, when it's bad, it's a
# disaster" languages.

{ config, options, lib, pkgs, ... }: {
  options.modules.dev.node.enable = lib.mkEnableOption "node";

  config =
    let node = pkgs.nodejs_latest;
    in lib.mkIf config.modules.dev.node.enable {
      home.packages = [
        node
        pkgs.yarn
      ];

      home.sessionPath = [ "$(${pkgs.yarn}/bin/yarn global bin)" ];

      # XDG settings
      home.sessionVariables = {
        NPM_CONFIG_USERCONFIG = "$HOME/.config/npm/config";
        NPM_CONFIG_CACHE      = "$XDG_CACHE_HOME/npm";
        NPM_CONFIG_TMP        = "$XDG_RUNTIME_DIR/npm";
        NPM_CONFIG_PREFIX     = "$XDG_CACHE_HOME/npm";
        NODE_REPL_HISTORY     = "$XDG_CACHE_HOME/node/repl_history";
      };

      xdg.configFile."npm/config".text = ''
        cache=${config.xdg.cacheHome}/npm
        prefix=${config.xdg.dataHome}/npm
      '';
    };
}
