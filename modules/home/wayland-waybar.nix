{ config, lib, pkgs, inputs, ... }: {

  options.modules.wayland.waybar.enable = lib.mkEnableOption "hyprland";

  config = lib.mkIf config.modules.wayland.waybar.enable {

    # NOTE: Waybar version, which allows for wlr/workspaces module
    nixpkgs.overlays = [
      (final: prev: {
        waybar = inputs.hyprland.packages.${final.system}.waybar-hyprland;
      })
    ];

    # Another way of doing the above:

    # Waybar needs to be compiled with the experimental flag for wlr/workspaces to work
    # nixpkgs.overlays = [
    #   (self: super: {
    #     waybar = super.waybar.overrideAttrs (oldAttrs: {
    #       mesonFlags = oldAttrs.mesonFlags ++ [ "-Dexperimental=true" ];
    #     });
    #   })
    # ];

    programs.waybar = {
      enable = true;
      systemd = {
        enable = true;
        target = "graphical-session.target";
      };
      # style = import ./style.nix colors;

      settings = [
        {
  # "layer" = "top", // Waybar at top layer
  # "position" = "bottom", // Waybar position (top|bottom|left|right)
          "height" = 20; # Waybar height (to be removed for auto height)
          # "width" = 1280; // Waybar width
          "spacing" = 15; # Gaps between modules (4px)
          "gtk-layer-shell" = false;
          # Choose the order of the modules
          "modules-left" = ["wlr/workspaces" "wlr/taskbar" "custom/media"];
          "modules-center" = ["custom/clock" "sway/window" "custom/weather"];
          "modules-right" = [
            "hyprland/language"
            "tray"
            "idle_inhibitor"
            "pulseaudio"
            # "network"
            "cpu"
            "custom/gpu-usage"
            "custom/pacman"
            "memory"
            "temperature"
            "backlight"
            "battery"
          ];

          # --- Modules configuration ---

          "wlr/workspaces" = {
            "disable-scroll" = true;
            "all-outputs" = true;
            "format" = "{icon}";
            # icons?:     
            "format-icons" = { #    - default-suggested ones
              # unicode-symbols below i pasted usint '(insert-char CHARACTER &optional COUNT INHERIT)'
              "urgent" = "⊕";
              "active" = "●";
              "default" = "○";
            };
          };
          "hyprland/language" = {
            "format" = "⌨ {}";
            # "format-us" = "AMERICA, HELL YEAH!",
            "keyboard-name" = "AT Translated Set 2 keyboard";
          };
          "wlr/taskbar" = {
            "icon-size" = 17;
            "format" = "{icon}";
          };
          "idle_inhibitor" = {
            "format" = "{icon}";
            "format-icons" = {"activated" = ""; "deactivated" = "";};
          };
          "tray" = {
            "icon-size" = 20;
            "spacing" = 5;
          };
          "cpu" = {
            "format" = "{usage}% ";
            "tooltip" = true;
          };
          # "network" = {
          # // "interface" = "wlp2*", // (Optional) To force the use of this interface
          # "format-wifi" = "{essid} ({signalStrength}%) ",
          # "format-ethernet" = "{ipaddr}/{cidr} ",
          # "tooltip-format" = "{ifname} via {gwaddr} ",
          # "format-linked" = "{ifname} {essid} (No IP) ",
          # "format-disconnected" = "Disconnected ⚠",
          # "format-alt" = "{ifname}: {ipaddr}/{cidr}"
          # },
          "pulseaudio" = {
            # "scroll-step" = 1, // %, can be a float
            "format" = "{volume}% {icon}";
            "format-bluetooth" = "{volume}% {icon} {format_source}";
            "format-bluetooth-muted" = " {icon} {format_source}";
            "format-muted" = " {format_source}";
            "format-icons" = {
              "headphone" = "";
              "hands-free" = "";
              "headset" = "";
              "phone" = "";
              "portable" = "";
              "car" = "";
              "default" = ["" "" ""];
            };
            "on-click" = "pavucontrol";
          };
          "memory" = {
            # "format" = "{}% "
            "format" = "{used:0.1f}G/{total:0.1f}G ";
          };
          "temperature" = {
            # "thermal-zone" = 2,
            # "hwmon-path" = "/sys/class/hwmon/hwmon2/temp1_input",
            "critical-threshold" = 80;
            # "format-critical" = "{temperatureC}°C {icon}",
            "format" = "{temperatureC} {icon}";
            "format-icons" = ["" "" ""];
          };
          "backlight" = {
            # "device" = "acpi_video1",
            "format" = "{percent}% {icon}";
            "format-icons" = [""];
          };
          "battery" = {
            "states" = {
              "good" = 90;
              "warning" = 30;
              "critical" = 15;
            };
            "format" = "{capacity}% {icon}";
            "format-charging" = "{capacity}% ";
            "format-plugged" = "{capacity}% ";
            "format-alt" = "{time} {icon}";
            # "format-good" = "", // An empty format will hide the module
            # "format-full" = "",
            "format-icons" = ["" "" "" "" ""];
          };

          # --- Custom widgets ---

          # Weather with detailed forecast
          # https://gist.github.com/bjesus/f8db49e1434433f78e5200dc403d58a3
          "custom/weather" = {
            "exec" = "curl 'https:#wttr.in/?format=1'";
            "interval" = 3600;
          };
          "custom/clock" = {
            # man date..
            "exec" = "date +'Day %j  |  %R  |  %a %d/%m'";
            "interval" = 2;
          };
          # alternate
          # "custom/pacman" = {
          # "format" = "{}  ",
          # "interval" = 3600,                     // every hour
          # "exec" = "checkupdates | wc -l",       // # of updates
          # "exec-if" = "exit 0",                  // always run; consider advanced run conditions
          # "on-click" = "alacritty -e 'sudo pacman -Syu'; pkill -SIGRTMIN+8 waybar", // update system
          # "signal" = 8
          # },
          # XXX: didn't find my 'gpu-busy-percent' file:
          # https://www.reddit.com/r/swaywm/comments/ncjpfz/how_to_add_gpu_usage_to_waybar/
          # "custom/gpu-usage" = {
          # "exec" = "cat /sys/class/hwmon/hwmon2/device/gpu_busy_percent",
          # "format" = "GPU: {}%",
          # "return-type" = "",
          # "interval" = 1
          # },
          # "custom/media" = {
          # "format" = "{icon} {}",
          # "return-type" = "json",
          # "max-length" = 40,
          # "format-icons" = {
          # "spotify" = "",
          # "default" = "🎜"
          # },
          # "escape" = true,
          # "exec" = "$HOME/.config/waybar/mediaplayer.py 2> /dev/null" // Script in resources folder
          # // "exec" = "$HOME/.config/waybar/mediaplayer.py --player spotify 2> /dev/null" // Filter player based on name
          # },
          "custom/media" = {
            "format" = "{icon} {}";
            "escape" = true;
            "return-type" = "json";
            "max-length" = 40;
            "on-click" = "playerctl play-pause";
            "on-click-right" = "playerctl stop";
            "smooth-scrolling-threshold" = 10; # This value was tested using a trackpad, it should be lowered if using a mouse.
            "on-scroll-up" = "playerctl next";
            "on-scroll-down" = "playerctl previous";
            "exec" = "~/.config/waybar/mediaplayer.py 2> /dev/null";
          };
        }
      ];

    };

    xdg.configFile = {
      "waybar/style.css".source = config.lib.file.mkOutOfStoreSymlink
        "${inputs.self}/config/waybar/style.css";
    };
  };
}