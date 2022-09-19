qutebrowser &
webcord &
emacs &
# syncthing & # starts in service
# syncthingtray --wait &
# for mako to work when not using systemd
# dbus-daemon --session --address=unix:path=$XDG_RUNTIME_DIR/bus &
mako &
hyprpaper &
waybar & # don't want to put it in systemd service
nm-applet --indicator &
brillo -c 2
brillo -I
wlsunset -l 55.7 -L 37.6 -t 3000 &
# /usr/lib/polkit-kde-authentication-agent-1 &

# TODO: -i <img> -s fill
swayidle -w \
	before-sleep 'swaylock -f -e -k -l -c 000000' &
