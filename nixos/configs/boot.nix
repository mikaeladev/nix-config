{ globals, pkgs, ... }:

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

  services.displayManager.ly = {
    enable = true;

    settings = rec {
      bg = "0x00111011";
      fg = "0x00FFFFFF";
      error_fg = "0x01AE5852";
      error_bg = bg;
      border_fg = fg;
      session_log = "${globals.mainuser.xdg.stateHome}/ly-session.log";
      text_in_center = true;
    };
  };
}
