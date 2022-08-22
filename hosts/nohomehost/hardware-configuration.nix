{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix")];

	boot = {
    initrd = {
      availableKernelModules = [ "xhci_pci" "nvme" "usb_storage" "sd_mod" "rtsx_usb_sdmmc" ];
      kernelModules = [ ];
    };
    extraModulePackages = [ ];
    kernelModules = [ "kvm-intel" ];
	};

  # Modules
  modules.hardware = {
    audio.enable = true;
    fs = {
      enable = true;
      ssd.enable = true;
    };
    nvidia.enable = true;
    sensors.enable = true;
    # bluetooth.enable = true;

    # Look those up in hlissners' dots if ya'll ever ened those
    # razer.enable = true;
    # ergodox.enable = true;
  };

  services.xserver.xkbOptions = "ctrl:swapcaps,grp:win_space_toggle";
	# Enable touchpad support (enabled default in most desktopManager).
  services.xserver.libinput.enable = true;

  # CPU
  # nix.settings.max-jobs = lib.mkDefault 16;
  powerManagement.cpuFreqGovernor = "performance"; # ondemand (default), powersave
  hardware.cpu.intel.updateMicrocode = true;

  # XXX: i didn't name my drives when i created them, name them and change it to
  # use labels
  fileSystems = {
    "/" = {
      device = "/dev/disk/by-uuid/190c09e6-5728-414f-a739-c32568d008c2";
      # device = "/dev/disk/by-label/nixos";
      fsType = "ext4";
      options = [ "noatime" ];
    };

    "/boot" = {
      device = "/dev/disk/by-uuid/5F27-9D3B";
      # device = "/dev/disk/by-label/BOOT";
      fsType = "vfat";
    };
  };

  swapDevices = [ ];
}
