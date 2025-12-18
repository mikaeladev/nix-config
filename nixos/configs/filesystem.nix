{ globals, ... }:

let
  efiDevice = "/dev/disk/by-uuid/B18D-67CD";
  nixosDevice = "/dev/disk/by-uuid/b9b31136-98f5-4ec9-b5e8-2b9b12bc4983";
  storageDevice = "/dev/disk/by-uuid/191e3f9d-df7c-4b99-8d03-1c2c65a1dc7b";
in

{
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
    
    "/home/${globals.mainuser.username}/storage" = {
      device = storageDevice;
      fsType = "btrfs";
      options = [
        "compress=zstd"
        "nofail"
      ];
    };
  };
}
