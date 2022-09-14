{ options, config, lib, pkgs, ... }:

let cfg = config.modules.desktop.vm.qemu;
in {
  options.modules.desktop.vm.qemu.enable = lib.mkEnableOption "qemu";

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      qemu
    ];
  };
}

# Creating an image:
#   qemu-img create -f qcow2 disk.img
# Creating a snapshot (don't tamper with disk.img):
#   qemu-img create -f qcow2 -b disk.img snapshot.img
