# General home-manaer configuratoin. It gets imported in each host

{ config, lib, ... }:

with builtins;
with lib;
{
	time.timeZone = mkDefault "Europe/Moscow";
	i18n.defaultLocale = mkDefault "en_US.UTF-8";
	# XXX: manage to use it for wayland nightshift analogue
	location = (if config.time.timeZone == "Europe/Moscow" then {
		latitude = 55.7;
		longitude = 37.6;
	} else {});
}
