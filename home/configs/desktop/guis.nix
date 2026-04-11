{ config, pkgs, ... }:

let
  generalFont = "SF Pro";
  monospaceFont = "JetBrains Mono";
  soundTheme = "ocean";
  cursorTheme = "pixel-cursors-default";
  cursorPackage = pkgs.pixel-cursors;
in

{
  home.packages = [
    # general fonts
    pkgs.apple-sf-pro

    # monospace fonts
    pkgs.jetbrains-mono
    pkgs.nerd-fonts.jetbrains-mono

    # emoji fonts
    pkgs.apple-emoji
  ];

  gtk = {
    enable = true;
    colorScheme = "dark";

    theme = {
      name = "WhiteSur-Dark";
      package = pkgs.whitesur-gtk-theme;
    };

    iconTheme = {
      name = "WhiteSur-dark";
      package = pkgs.whitesur-icon-theme;
    };

    font = {
      name = generalFont;
      size = 10;
    };

    gtk2 = {
      configLocation = "${config.xdg.configHome}/gtk-2.0/gtkrc";
      extraConfig = ''
        gtk-button-images=1
        gtk-cursor-blink=1;
        gtk-cursor-blink-time=1000;
        gtk-enable-animations=1;
        gtk-menu-images=1
        gtk-toolbar-style=3
      '';
    };

    gtk3.extraConfig = {
      gtk-button-images = true;
      gtk-cursor-blink = true;
      gtk-cursor-blink-time = 1000;
      gtk-decoration-layout = "close,minimize,maximize:";
      gtk-enable-animations = true;
      gtk-menu-images = true;
      gtk-modules = "colorreload-gtk-module:window-decorations-gtk-module";
      gtk-primary-button-warps-slider = true;
      gtk-sound-theme-name = soundTheme;
      gtk-toolbar-style = 3; # icons and text alongside each other
    };

    gtk4 = {
      theme = config.gtk.theme;
      extraConfig = {
        gtk-cursor-blink = true;
        gtk-cursor-blink-time = 1000;
        gtk-decoration-layout = "close,minimize,maximize:";
        gtk-enable-animations = true;
        gtk-primary-button-warps-slider = true;
        gtk-sound-theme-name = soundTheme;
      };
    };
  };

  qt = {
    enable = true;

    kvantum = {
      enable = true;
      themes = [ pkgs.whitesur-kde ];
      settings.General.theme = "WhiteSurDark";
    };

    style = {
      name = "kvantum";
      package = with pkgs; [
        libsForQt5.qtstyleplugin-kvantum
        kdePackages.qtstyleplugin-kvantum
      ];
    };
  };

  fonts.fontconfig = {
    enable = true;
    antialiasing = true;
    subpixelRendering = "none";
    hinting = "slight";

    defaultFonts = {
      serif = [ generalFont ];
      sansSerif = [ generalFont ];
      monospace = [ monospaceFont ];
    };
  };

  home.pointerCursor = {
    enable = true;
    gtk.enable = true;
    dotIcons.enable = false;
    name = cursorTheme;
    package = cursorPackage;
    size = 24;
  };

  xdg.dataFile."icons/${cursorTheme}".source =
    "${cursorPackage}/share/icons/${cursorTheme}";
}
