{ lib, modulesPath, ... }:

{
  imports = [ (modulesPath + "/profiles/qemu-guest.nix") ];

  boot = {
    kernelModules = [ "kvm-amd" ];
    extraModulePackages = [ ];
    initrd = {
      kernelModules = [ ];
      availableKernelModules = [
        "ahci"
        "xhci_pci"
        "virtio_pci"
        "sr_mod"
        "virtio_blk"
      ];
    };
  };

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-uuid/bee75207-3587-4cff-9115-830b012478d9";
      fsType = "btrfs";
      options = [ "subvol=root" ];
    };
    "/nix" = {
      device = "/dev/disk/by-uuid/bee75207-3587-4cff-9115-830b012478d9";
      fsType = "btrfs";
      options = [ "subvol=nix" ];
    };
    "/home" = {
      device = "/dev/disk/by-uuid/bee75207-3587-4cff-9115-830b012478d9";
      fsType = "btrfs";
      options = [ "subvol=home" ];
    };
    "/boot" = {
      device = "/dev/disk/by-uuid/25D8-6D56";
      fsType = "vfat";
      options = [
        "fmask=0022"
        "dmask=0022"
      ];
    };
  };

  swapDevices = [ ];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}
