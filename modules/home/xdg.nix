# xdg.nix
#
# Set up and enforce XDG compliance. Other modules will take care of their own,
# but this takes care of the general cases.

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

  home.sessionPath = [ "$XDG_BIN_HOME" ];

  # REVIEW: don't think it should b here
  home.sessionVariables = {
    HISTFILE     = "$XDG_DATA_HOME/bash/history";
    LESSHISTFILE = "$XDG_CACHE_HOME/lesshst";
  };
}
