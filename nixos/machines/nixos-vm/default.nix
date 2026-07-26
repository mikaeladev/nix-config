{
  imports = [ ./hardware.nix ];

  fileSystems = {
    "/".options = [ "compress=zstd" ];
    "/nix".options = [
      "compress=zstd"
      "noatime"
    ];
    "/home".options = [ "compress=zstd" ];
    "/boot".options = [ "umask=0077" ];
  };

  networking.hostName = "nixos-vm";

  system.stateVersion = "26.11";
}
