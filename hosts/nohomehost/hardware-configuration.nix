{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix")];

  boot = {
    initrd = {
      availableKernelModules =
        [ "xhci_pci" "nvme" "usb_storage" "sd_mod" "rtsx_usb_sdmmc" ]; # "usbhid" "uas"
      kernelModules = [ ];
    };
    extraModulePackages = [ ];
    kernelModules = [ "kvm-intel" ];

    kernelParams = [
      # HACK Disables fixes for spectre, meltdown, L1TF and a number of CPU
      #      vulnerabilities. Don't copy this blindly! And especially not for
      #      mission critical or server/headless builds exposed to the world.
      "mitigations=off"
    ];

    # Refuse ICMP echo requests on my desktop/laptop; nobody has any business
    # pinging them, unlike my servers.
    kernel.sysctl."net.ipv4.icmp_echo_ignore_broadcasts" = 1;

    # REVIEW: do i need it when having ntfs3g package installed?
    # supportedFilesystems = [ "ntfs" ];
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

  # Power management
  environment.systemPackages = [ pkgs.acpi ];
  powerManagement.powertop.enable = true;
  # systemd.services.powertop.wantedBy = [ "suspend.target" ];
  # systemd.services.powertop.after = [ "suspend.target" ];

  # Networking
  # Without this wpa_supplicant may fail to auto-discover wireless interfaces at
  # startup (and must be restarted).
  # networking.wireless.interfaces = [ "wlp2s0" ];
  # networking.interfaces = {
  #   enp42s0.useDHCP = true;
  #   wlo1.useDHCP = true;
  # };

  # Xbox controller support
  # hardware.xpadneo.enable = true;

  # REVIEW: documentation for this option doens't explain anything...
  # hardware.bluetooth.enable = true;

  # CPU
  # nix.settings.max-jobs = lib.mkDefault 16; # REVIEW
  # ondemand (default), powersave, performance
  powerManagement.cpuFreqGovernor = "powersave";
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
