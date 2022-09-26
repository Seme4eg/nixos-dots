{ config, options, lib, pkgs, inputs, ... }:

let cfg = config.modules.shell.git;
in {
  options.modules.shell.git.enable = lib.mkEnableOption "git";

  config = lib.mkIf cfg.enable {
    programs.git = {
      userName = "Seme4eg";
      userEmail = "418@duck.com";
    };

    xdg.configFile = {
      "git/config".source = "${inputs.self}/config/git/config";
      "git/ignore".source = "${inputs.self}/config/git/ignore";
    };

    modules.shell.zsh.rcFiles = [ "${inputs.self}/config/git/aliases.zsh" ];
  };
}
