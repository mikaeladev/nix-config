{ globals, pkgs, ... }:

{
  environment = {
    systemPackages = with pkgs; [
      kitty
      vim
      file
      unzip
      curl
      wget
      jq
    ];

    plasma6 = {
      excludePackages = with pkgs.kdePackages; [
        discover
        kdeconnect-kde
        kgpg
        khelpcenter
        kolourpaint
        konsole
      ];
    };

    pathsToLink = [
      "/share/xdg-desktop-portal"
      "/share/applications"
    ];

    variables = {
      EDITOR = "vi";
      PAGER = "less";
    };

    sessionVariables = {
      # enable stem-darkening for all fonts
      FREETYPE_PROPERTIES = "cff:no-stem-darkening=0 autofitter:no-stem-darkening=0";
      # enable PIP wayland protocol
      KWIN_WAYLAND_SUPPORT_XX_PIP_V1 = 1;
    };
  };

  xdg.portal = {
    enable = true;
    xdgOpenUsePortal = true;

    extraPortals = with pkgs; [
      kdePackages.xdg-desktop-portal-kde
      xdg-desktop-portal-gtk
    ];
  };

  time.timeZone = "Europe/London";

  i18n = rec {
    defaultLocale = "en_GB.UTF-8";
    extraLocaleSettings = {
      LC_ADDRESS = defaultLocale;
      LC_IDENTIFICATION = defaultLocale;
      LC_MEASUREMENT = defaultLocale;
      LC_MONETARY = defaultLocale;
      LC_NAME = defaultLocale;
      LC_NUMERIC = defaultLocale;
      LC_PAPER = defaultLocale;
      LC_TELEPHONE = defaultLocale;
      LC_TIME = defaultLocale;
    };
  };

  programs = {
    zsh.enable = true;
    git.enable = true;
    dconf.enable = true;
    xwayland.enable = true;

    gamescope = {
      enable = true;
      enableWsi = true;
    };

    steam = {
      enable = true;
      protontricks.enable = true;
      dedicatedServer.openFirewall = true;
      extraCompatPackages = [ pkgs.proton-ge-bin ];
      extraPackages = [ pkgs.gamemode ];
    };
  };

  # enable realtime scheduling
  security.rtkit.enable = true;

  services = {
    flatpak.enable = true;
    openssh.enable = true;

    # ly display manager
    displayManager.ly = {
      enable = true;
      x11Support = false;
      settings = {
        session_log = "${globals.xdgBaseDirectoryParts.stateHome}/ly-session.log";
        text_in_center = true;
      };
    };

    # kde plasma desktop environment
    desktopManager.plasma6 = {
      enable = true;
      enableQt5Integration = true;
    };

    # pipewire with pulse emulation
    pulseaudio.enable = false;
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };
  };
}
