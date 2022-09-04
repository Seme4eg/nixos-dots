# https://github.com/hlissner/doom-emacs.

{ config, lib, pkgs, inputs, ... }:

with lib;
with lib.my;
let cfg = config.modules.editors.emacs;
    configDir = config.dotfiles.configDir;
in {
  options.modules.editors.emacs = {
    enable = mkBoolOpt false;
    doom = rec {
      enable = mkBoolOpt false;

      # XXX: doesn't work, throws an error
      forgeUrl = mkOpt types.str "https://github.com";
      repoUrl = mkOpt types.str "${forgeUrl}/doomemacs/doomemacs"; 
      configRepoUrl = mkOpt types.str "${forgeUrl}/Seme4eg/.doom.d.git";

      # This as well...
      # forgeUrl = mkOpt types.str "https://github.com/";
      # repoUrl = mkOpt types.str "https://github.com/doomemacs/doomemacs";
      # configRepoUrl = mkOpt types.str "https://github.com/Seme4eg/.doom.d.git";
    };
  };

  config = mkIf cfg.enable {
    nixpkgs.overlays = [ inputs.emacs-overlay.overlay ];

    user.packages = with pkgs; [
      ## Emacs itself
      binutils       # native-comp needs 'as', provided by this
      # 29 + pgtk + native-comp
      ((emacsPackagesFor emacsPgtkNativeComp).emacsWithPackages
        (epkgs: [ epkgs.vterm ]))

      ## Doom dependencies
      git
      (ripgrep.override {withPCRE2 = true;})
      gnutls              # for TLS connectivity

      ## Optional dependencies
      fd                  # faster projectile indexing
      imagemagick         # for image-dired
      (mkIf (config.programs.gnupg.agent.enable)
        pinentry_emacs)   # in-emacs gnupg prompts
      zstd                # for undo-fu-session/undo-tree compression

      ## Module dependencies
      # :checkers spell
      (aspellWithDicts (ds: with ds; [ en en-computers en-science ]))
      # :tools editorconfig
      editorconfig-core-c # per-project style config
      # :tools lookup & :lang org +roam
      sqlite
      # :lang latex & :lang org (latex previews)
      #texlive.combined.scheme-medium
      # :lang beancount
      # beancount
      unstable.fava  # HACK Momentarily broken on nixos-unstable

      # Telegram
      tdlib
    ];

    env.PATH = [ "$XDG_CONFIG_HOME/emacs/bin" ];

    modules.shell.zsh.rcFiles = [ "${configDir}/emacs/aliases.zsh" ];

    fonts.fonts = [ pkgs.emacs-all-the-icons-fonts ];

    systemd.tmpfiles.rules = [
      # Static symlink for nix.nixPath, which controls $NIX_PATH. Using nixpkgs input directly would
      # result in $NIX_PATH containing a /nix/store value, which would be inaccurate after the first
      # nixos-rebuild switch until logging out (and prone to garbage collection induced breakage).
      "L+ ${config.user.home}/.local/bin/tdlib - - - - ${pkgs.tdlib}"
    ];

    # XXX: Why using user activation scripts is disencouraged?
    system.userActivationScripts = mkIf cfg.doom.enable {
      # XXX: script doesn't work
      installDoomEmacs = {
        text = ''
          if [ ! -d "$XDG_CONFIG_HOME/emacs" ]; then
            git clone --depth=1 --single-branch https://github.com/doomemacs/doomemacs "$XDG_CONFIG_HOME/emacs"
            git clone https://github.com/Seme4eg/.doom.d.git "$XDG_CONFIG_HOME/doom"
          fi
        '';
      };
    };

    # viper
    # system.userActivationScripts = let
    #   doom = pkgs.fetchFromGitHub {
    #     owner = ""; repo = ""; rev = ""; hash = "";
    #   }; in ''
    #   if [ ! -d folder ]; then
    #     cp ${doom} folder
    #   fi
    #   '';

    # NOTE: this script does work
    # Installation script every time nixos-rebuild is run. So not during initial install.
    # system.userActivationScripts = {                    
    #   doomEmacs = {
    #     text = ''
    #     source ${config.system.build.setEnvironment}
    #     DOOM="$HOME/.emacs.d"

    #     if [ ! -d "$DOOM" ]; then
    #       git clone https://github.com/hlissner/doom-emacs.git $DOOM
    #       yes | $DOOM/bin/doom install
    #       rm -r $HOME/.doom.d
    # git clone https://github.com/Seme4eg/.doom.d.git /etc/dotfiles/modules/editos/emacs/.doom.d
    #       ln -s /etc/dotfiles/modules/editors/emacs/doom.d $HOME/.doom.d
    #       $DOOM/bin/doom sync
    #     else
    #       $DOOM/bin/doom sync
    #     fi
    #   '';
    #   };
    # };
  };
}
