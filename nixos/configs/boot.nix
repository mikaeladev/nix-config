{
  globals,
  lib,
  pkgs,
  ...
}:

let
  inherit (globals) mkXdgBaseDirectoryPaths;
  inherit (lib) removePrefix;

  lySessionLogPathBase = removePrefix "/" (mkXdgBaseDirectoryPaths "").stateHome;
in

{
  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    kernelModules = [ "kvm-amd" ];
    extraModulePackages = [ ];

    initrd = {
      kernelModules = [ ];
      availableKernelModules = [
        "xhci_pci"
        "ahci"
        "nvme"
        "usbhid"
        "usb_storage"
        "sd_mod"
      ];
    };

    loader = {
      timeout = 10;
      efi.canTouchEfiVariables = true;

      systemd-boot = {
        enable = true;
        editor = false;
        configurationLimit = 50;
      };
    };

    tmp = {
      useTmpfs = true;
      tmpfsSize = "30%";
    };
  };

  services.displayManager.ly = {
    enable = true;

    settings = rec {
      bg = "0x00111011";
      fg = "0x00FFFFFF";
      error_fg = "0x01AE5852";
      error_bg = bg;
      border_fg = fg;
      session_log = "${lySessionLogPathBase}/ly-session.log";
      text_in_center = true;
    };
  };
}
