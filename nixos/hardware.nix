{ globals, ... }:

{
  services.xserver.videoDrivers = [ "nvidia" ];

  hardware = {
    graphics.enable = true;
    enableRedistributableFirmware = true;

    nvidia = {
      open = false;
      nvidiaSettings = false;
    };
  };

  zramSwap = {
    enable = true;
    priority = 100;
    memoryPercent = 25; # 8G
    algorithm = "zstd";
  };

  fileSystems = {
    "/boot" = {
      device = "/dev/disk/by-uuid/" + globals.efiDevice;
      fsType = "vfat";
      options = [ "umask=0077" ];
    };

    "/" = {
      device = "/dev/disk/by-uuid/" + globals.nixosDevice;
      fsType = "btrfs";
      options = [
        "compress=zstd"
        "subvol=@root"
      ];
    };

    "/nix" = {
      device = "/dev/disk/by-uuid/" + globals.nixosDevice;
      fsType = "btrfs";
      options = [
        "compress=zstd"
        "subvol=@nix"
        "noatime"
      ];
    };

    "/home" = {
      device = "/dev/disk/by-uuid/" + globals.nixosDevice;
      fsType = "btrfs";
      options = [
        "compress=zstd"
        "subvol=@home"
      ];
    };
  }
  // (
    if builtins.isAttrs globals.storageDevice then
      {
        ${globals.storageDevice.mountPoint} = {
          device = "/dev/disk/by-uuid/" + globals.storageDevice.uuid;
          fsType = "btrfs";
          options = [
            "compress=zstd"
            "nofail"
          ];
        };
      }
    else
      { }
  );
}
