{ config, options, pkgs, inputs, lib, ... }:

let cfg = config.modules.shell.zsh;
in {
  options.modules.shell.zsh = {
    enable = lib.mkEnableOption "zsh";
    rcInit = lib.mkOption {
      type = lib.types.lines;
      default = "";
      description = ''
        Zsh lines to be written to $XDG_CONFIG_HOME/zsh/extra.zshrc and sourced by
        $XDG_CONFIG_HOME/zsh/.zshrc
      '';
    };
    rcFiles = lib.mkOption {
      type = (with lib.types; listOf (either str path));
      default = [];
    };
  };

  config = lib.mkIf cfg.enable {
    users.defaultUserShell = pkgs.zsh;

    programs.zsh = {
      enable = true;
      enableCompletion = true;
      syntaxHighlighting.enable = true;
      # I init completion myself, because enableGlobalCompInit initializes it
      # too soon, which means commands initialized later in my config won't get
      # completion, and running compinit twice is slow.
      enableGlobalCompInit = false;
      promptInit = "";
    };

    user.packages = with pkgs; [
      bat # A cat(1) clone with syntax highlighting and Git integration
      exa # modern replacement for the command-line program ls

      fasd # Quick command-line access to files and directories for POSIX shells
      # zoxide # A fast cd command that learns your habits

      fd # A simple, fast and user-friendly alternative to find
      fzf
      # jq # command line JSON processor
      ripgrep
      tldr # Simplified and community-driven man pages
    ];

    env = {
      ZDOTDIR   = "$XDG_CONFIG_HOME/zsh";
      ZSH_CACHE = "$XDG_CACHE_HOME/zsh";
      ANTIDOTE_DIR  = "$XDG_DATA_HOME/antidote";
    };

    home.configFile = {
      "zsh" = { source = "${inputs.self}/config/zsh"; recursive = true; };
      # Why am I creating extra.zsh{rc,env} when I could be using extraInit?
      # Because extraInit generates those files in /etc/profile, and mine just
      # write the files to ~/.config/zsh; where it's easier to edit and tweak
      # them in case of issues or when experimenting.
      "zsh/extra.zshrc".text =
        ''
           # This file was autogenerated, do not edit it!
           ${lib.concatMapStrings (path: "source '${path}'\n") cfg.rcFiles}
           ${cfg.rcInit}
        '';
    };

    system.userActivationScripts.cleanupZsh = ''
      rm -rf $ZSH_CACHE
      rm -fv $ZDOTDIR/plugins.zsh
    '';
  };
}
