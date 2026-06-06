{ pkgs, ... }:

{
  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    kernelModules = [
      "kvm-amd"
      "k10temp"
      "ntsync"
    ];

    initrd = {
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

      limine = {
        enable = true;
        maxGenerations = 50;

        # rose-pine
        # https://github.com/rose-pine/limine
        style.graphicalTerminal = {
          palette = "191724;eb6f92;9ccfd8;f6c177;31748f;c4a7e7;9ccfd8;e0def4";
          brightPalette = "6e6a86;eb6f92;9ccfd8;f6c177;31748f;c4a7e7;9ccfd8;e0def4";
          background = "191724";
          brightBackground = "6e6a86";
          foreground = "e0def4";
          brightForeground = "e0def4";
        };
      };
    };

    tmp = {
      useTmpfs = true;
      tmpfsSize = "30%";
    };
  };
}
