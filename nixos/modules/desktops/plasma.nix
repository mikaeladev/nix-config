{ pkgs, ... }:

{
  programs.xwayland.enable = true;

  services.displayManager = {
    plasma6.enable = true;

    sddm = {
      enable = true;
      wayland.enable = true;
    };
  };

  xdg.portal = {
    enable = true;
    xdgOpenUsePortal = true;
    
    extraPortals = [
      pkgs.kdePackages.xdg-desktop-portal-kde
      pkgs.xdg-desktop-portal-gtk
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
}
