{ config, options, lib, pkgs, ... }:

let cfg = config.modules.shell.git;
    configDir = config.dotfiles.configDir;
in {
  options.modules.shell.git.enable = lib.mkEnableOption "git";

  config = lib.mkIf cfg.enable {
    # user.packages = with pkgs; [
      # gitAndTools.git-annex
      # unstable.gitAndTools.gh
      # gitAndTools.git-open
      # gitAndTools.diff-so-fancy
      # (mkIf config.modules.shell.gnupg.enable
        # gitAndTools.git-crypt)
      # act
    # ];

    home.configFile = {
      "git/config".source = "${configDir}/git/config";
      "git/ignore".source = "${configDir}/git/ignore";
    };

    modules.shell.zsh.rcFiles = [ "${configDir}/git/aliases.zsh" ];
  };
}
