{ config, lib, pkgs, inputs, ... }:

let cfg = config.modules.editors.emacs;
    configDir = config.dotfiles.configDir;
in {
  options.modules.editors.emacs = {
    enable = lib.mkEnableOption "emacs";
    doom = {
      enable = lib.mkEnableOption "doom";
    };
  };

  config = lib.mkIf cfg.enable {
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
      (lib.mkIf (config.programs.gnupg.agent.enable)
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

      # Telegram
      tdlib
    ];

    services.locate = {
      locate = pkgs.plocate;
      enable = true;
      interval = "hourly";
      localuser = null;
    };

    env.PATH = [ "$XDG_CONFIG_HOME/emacs/bin" ];

    modules.shell.zsh.rcFiles = [ "${configDir}/emacs/aliases.zsh" ];

    fonts.fonts = [ pkgs.emacs-all-the-icons-fonts ];

    systemd.tmpfiles.rules = [
      # Static symlink for nix.nixPath, which controls $NIX_PATH. Using nixpkgs input directly would
      # result in $NIX_PATH containing a /nix/store value, which would be inaccurate after the first
      # nixos-rebuild switch until logging out (and prone to garbage collection induced breakage).
      "L+ ${config.user.home}/.local/bin/tdlib - - - - ${pkgs.tdlib}"
    ];

    system.userActivationScripts = lib.mkIf cfg.doom.enable {
      installDoomEmacs = let
        doom = pkgs.fetchFromGitHub {
          owner = "doomemacs";
          repo = "doomemacs";
          rev = "c44bc81a05f3758ceaa28921dd9c830b9c571e61";
          hash = "sha256-3apl0eQlfBj3y0gDdoPp2M6PXYnhxs0QWOHp8B8A9sc=";
        };

        myconfig = pkgs.fetchFromGitHub {
          owner = "Seme4eg";
          repo = ".doom.d";
          rev = "711de97fad87bdd94e31ac730a599edd7503cb09";
          hash = "sha256-+pOfW2AnePJ2RqnpXaZjuF7GO4WRk67wOle0cABkidw=";
          stripRoot = false;
        };
      in
        ''
          [ ! -d "$XDG_CONFIG_HOME/emacs" ] && cp ${doom} "$XDG_CONFIG_HOME/emacs"
          [ ! -d "$XDG_CONFIG_HOME/doom" ] && cp ${myconfig} "$XDG_CONFIG_HOME/doom"
        '';
      };
    };
}
