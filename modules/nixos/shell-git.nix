{ config, options, lib, pkgs, inputs, ... }:

let cfg = config.modules.shell.git;
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
      "git/config".source = "${inputs.self}/config/git/config";
      "git/ignore".source = "${inputs.self}/config/git/ignore";
    };

    modules.shell.zsh.rcFiles = [ "${inputs.self}/config/git/aliases.zsh" ];
  };
}