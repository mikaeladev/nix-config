{
  config,
  lib,
  pkgs,
  ...
}:

{
  options.desktops.plasma.enable = lib.mkEnableOption "Plasma Desktop";

  config = lib.mkIf config.desktops.plasma.enable {
    services.desktopManager.plasma6.enable = true;

    xdg.portal = {
      enable = true;
      xdgOpenUsePortal = true;

      extraPortals = with pkgs; [
        kdePackages.xdg-desktop-portal-kde
        xdg-desktop-portal-gtk
      ];
    };

    environment = {
      pathsToLink = [
        "/share/xdg-desktop-portal"
        "/share/applications"
      ];

      plasma6.excludePackages = with pkgs.kdePackages; [
        discover
        kdeconnect-kde
        kgpg
        khelpcenter
        kolourpaint
        konsole
      ];

      sessionVariables = {
        FREETYPE_PROPERTIES = "cff:no-stem-darkening=0 autofitter:no-stem-darkening=0";
        KWIN_WAYLAND_SUPPORT_XX_PIP_V1 = 1; # enable PIP wayland protocol
      };
    };
  };
}
