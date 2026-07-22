{
  # services.xserver.videoDrivers = [ "nvidia" ];

  # hardware = {
  #   graphics.enable = true;
  #   enableRedistributableFirmware = true;

  #   nvidia = {
  #     open = false;
  #     nvidiaSettings = false;
  #   };
  # };

  # fileSystems = {
  #   "/boot".options = [ "umask=0077" ];

  #   "/".options = [
  #     "compress=zstd"
  #     "subvol=@root"
  #   ];

  #   "/home".options = [
  #     "compress=zstd"
  #     "subvol=@home"
  #   ];

  #   "/nix".options = [
  #     "compress=zstd"
  #     "subvol=@nix"
  #     "noatime"
  #   ];

  #   ${config.globals.storage.mountPath} = mkIf config.globals.storage.enable {
  #     device = "/dev/disk/by-uuid/" + config.globals.storage.uuid;
  #     fsType = "btrfs";
  #     options = [
  #       "compress=zstd"
  #       "nofail"
  #     ];
  #   };
  # };
}
