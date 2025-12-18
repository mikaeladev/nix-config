{ pkgs, ... }:

{
  boot = {
    # use standard linux kernel
    kernelPackages = pkgs.linuxPackages_latest;

    # use systemd boot loader
    loader = {
      timeout = 10;
      efi.canTouchEfiVariables = true;

      systemd-boot = {
        enable = true;
        editor = false;
        configurationLimit = 50;
      };
    };

    # use tmpfs for /tmp
    tmp = {
      useTmpfs = true;
      tmpfsSize = "30%";
    };

    # enable splash screen
    plymouth = {
      enable = true;
      theme = "mac-style";
      themePackages = [ pkgs.mac-style-plymouth ];
    };
  };
}
