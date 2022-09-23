# modules/browser/qutebrowser.nix --- https://github.com/qutebrowser/qutebrowser
#
# Qutebrowser is cute because it's not enough of a browser to be handsome.
# Still, we can all tell he'll grow up to be one hell of a lady-killer.

{ options, config, lib, inputs, pkgs, ... }:

let cfg = config.modules.desktop.browsers.qutebrowser;
in {
  options.modules.desktop.browsers.qutebrowser = {
    enable = lib.mkEnableOption "qutebrowser";
    userStyles = lib.mkOption { type = lib.types.lines; default = ""; };
  };

  config = lib.mkIf cfg.enable {
    programs.qutebrowser = {
      enable = true;
      # https://nix-community.github.io/home-manager/options.html#opt-programs.qutebrowser.quickmarks
      # quickmarks = { ... }; # TODO: work for sops-nix
    };

    home.packages = with pkgs; [

      (python3.withPackages (p: with p; [
        # For Brave adblock in qutebrowser, which is significantly better than the
        # built-in host blocking. Works on youtube and crunchyroll ads!
        adblock

        # For userscript code-select to use newline as delimeter, nor ';'

        # (Suggestion from discord server):
        # In that case, the standard solution is to make a flake.nix/default.nix
        # with buildPythonApplication/buildPythonPackage You can also just use
        # patchShebangs
        pyperclip # TODO: doesn't work
        # userScriptsPatchShebang = # this also doesn't work
        #   ''patchShebangs ${inputs.self}/config/qutebrowser/userscripts'';
      ]))

    ];

    xdg.configFile = {
      "qutebrowser" = {
        source = "${inputs.self}/config/qutebrowser";
        recursive = true;
      };
    };

    # TODO: i guess it's for theming?
    # xdg.dataFile."qutebrowser/userstyles.css".text = cfg.userStyles;

    # Run scripts during rebuild/switch
    home.activation = {
      # let inherit (config.home) homeDirectory; in
      qbCreateDownloadDir = config.lib.dag.entryAnywhere
        ''[ ! -d "$HOME/Downloads" ] && mkdir $HOME/Downloads;'';

      # Install language dictionaries for spellcheck backends
      qbInstallDicts = lib.concatStringsSep "\\\n" (map (lang: ''
          if ! find "$XDG_DATA_HOME/qutebrowser/qtwebengine_dictionaries" -type d -maxdepth 1 -name "${lang}*" 2>/dev/null | grep -q .; then
            ${pkgs.python3}/bin/python ${pkgs.qutebrowser}/share/qutebrowser/scripts/dictcli.py install ${lang}
          fi
        '') [ "en-US" "ru-RU" ]);
    };
  };
}
