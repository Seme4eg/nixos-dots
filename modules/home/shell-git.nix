{ config, options, lib, pkgs, inputs, ... }:

let cfg = config.modules.shell.git;
in {
  options.modules.shell.git.enable = lib.mkEnableOption "git";

  config = lib.mkIf cfg.enable {
    # home.packages = with pkgs; [
      # gitAndTools.git-annex
      # gitAndTools.git-open
      # gitAndTools.diff-so-fancy
      # act
    # ];

    programs = {
      git = {
        enable = true;
        userName = "Seme4eg";
        userEmail = "418@duck.com";
      };
    };

    xdg.configFile = {
      "git/config".source = "${inputs.self}/config/git/config";
      "git/ignore".source = "${inputs.self}/config/git/ignore";
    };

    # XXX: bring back
    # modules.shell.zsh.rcFiles = [ "${inputs.self}/config/git/aliases.zsh" ];
  };
}
