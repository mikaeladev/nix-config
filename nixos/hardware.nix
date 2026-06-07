{ globals, pkgs, ... }:

let
  efiDevice = "/dev/disk/by-uuid/B18D-67CD";
  nixosDevice = "/dev/disk/by-uuid/b9b31136-98f5-4ec9-b5e8-2b9b12bc4983";
in

{
  nixpkgs.hostPlatform = pkgs.stdenv.hostPlatform.system;

  services.xserver.videoDrivers = [ "nvidia" ];

  hardware = {
    graphics.enable = true;
    cpu.amd.updateMicrocode = true;

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
    "/" = {
      device = nixosDevice;
      fsType = "btrfs";
      options = [
        "compress=zstd"
        "subvol=@"
      ];
    };

    "/boot" = {
      device = efiDevice;
      fsType = "vfat";
      options = [ "umask=0077" ];
    };

    "/home" = {
      device = nixosDevice;
      fsType = "btrfs";
      options = [
        "compress=zstd"
        "subvol=@home"
      ];
    };
  }
  // (
    if builtins.isAttrs globals.storage then
      {
        ${globals.storage.mountPoint} = {
          device = "/dev/disk/by-uuid/${globals.storage.uuid}";
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
