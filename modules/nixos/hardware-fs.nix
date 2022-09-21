# In case u'll need to know how to setup zfs - check it in hlissnets' dots

{ config, options, lib, pkgs, ... }:

let cfg = config.modules.hardware.fs;
in {
  options.modules.hardware.fs.enable = lib.mkEnableOption "fs";

  config = lib.mkIf cfg.enable {
    programs.udevil.enable = true;

    # Support for more filesystems, mostly to support external drives
    environment.systemPackages = with pkgs; [
      sshfs
      exfat     # Windows drives
      ntfs3g    # Windows drives
      # hfsprogs  # MacOS drives
    ];

    services.fstrim.enable = true;
};
}
