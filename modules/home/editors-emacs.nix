{ config, lib, pkgs, inputs, ... }: {
  options.modules.emacs.enable = lib.mkEnableOption "emacs";

  config = lib.mkIf config.modules.emacs.enable {
    home.packages = with pkgs; [
      ## Emacs itself
      binutils       # native-comp needs 'as', provided by this
      # 29 + pgtk + native-comp
      ((emacsPackagesFor emacsPgtkNativeComp).emacsWithPackages
        (epkgs: with epkgs; [
          vterm
          telega
        ]))

      ## Doom dependencies
      (ripgrep.override {withPCRE2 = true;})
      gnutls              # for TLS connectivity

      ## Optional dependencies
      fd                  # faster projectile indexing
      imagemagick         # for image-dired
      # TODO: when going to setup mu4e - uncomment it and enable programs.gnupg.agent
      # (lib.mkIf (config.programs.gnupg.agent.enable)
      #   pinentry_emacs)   # in-emacs gnupg prompts
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
    ];

    home.sessionPath = [ "${config.xdg.configHome}/emacs/bin" ];

    modules.shell.zsh.rcFiles = [ "${inputs.self}/config/emacs/aliases.zsh" ];

    home.activation = {
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
          [ ! -d "${config.xdg.configHome}/emacs" ] &&
            cp ${doom} "${config.xdg.configHome}/emacs"
          [ ! -d "${config.xdg.configHome}/doom" ] &&
            cp ${myconfig} "${config.xdg.configHome}/doom"
        '';
      };
    };
}
