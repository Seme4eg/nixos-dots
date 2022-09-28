# xdg.nix
#
# Set up and enforce XDG compliance. Other modules will take care of their own,
# but this takes care of the general cases.
#
# https://github.com/nix-community/home-manager/blob/master/modules/misc/xdg.nix#blob-path

{ config, ... }:
let
  browser = ["qutebrowser.desktop"]; # ["firefox.desktop"];

  associations = {
    "x-scheme-handler/http" = browser;
    "x-scheme-handler/https" = browser;
    "x-scheme-handler/ftp" = browser;
    "x-scheme-handler/about" = browser;
    "x-scheme-handler/unknown" = browser;

    # "text/html" = browser;
    "text/*" = [ "emacs.desktop" ];
    "audio/*" = ["mpv.desktop"];
    "video/*" = ["mpv.dekstop"];
    # "image/*" = ["imv.desktop"];

    "application/json" = browser;
    "application/pdf" = ["emacs.desktop"];
    "x-scheme-handler/discord" = ["WebCord.desktop"];
  };
in
{
  xdg.mimeApps = {
    enable = true;
    defaultApplications = associations;
  };

  home.sessionPath = [ "${config.home.homeDirectory}/.local/bin" ];

  # REVIEW: don't think it should b here
  home.sessionVariables = {
    HISTFILE     = "${config.xdg.dataHome}/bash/history";
    LESSHISTFILE = "${config.xdg.cacheHome}/lesshst";
  };
}
