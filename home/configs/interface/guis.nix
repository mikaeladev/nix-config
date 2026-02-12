{
  config,
  globals,
  lib,
  pkgs,
  ...
}:

let
  soundTheme = "ocean";
  qtStyle = "kvantum";
  kvantumTheme = "WhiteSurDark";
  kdeTheme = "WhiteSur-dark";
  kdePackage = pkgs.whitesur-kde;
in

{
  home.packages = [
    pkgs.whitesur-gtk-theme
    kdePackage
  ];

  gtk = rec {
    enable = true;

    colorScheme = "dark";
    theme.name = "WhiteSur-Dark";

    gtk2 = {
      configLocation = "${config.xdg.configHome}/gtk-2.0/gtkrc";
      extraConfig = ''
        gtk-button-images=1
        gtk-cursor-blink=1;
        gtk-cursor-blink-time=1000;
        gtk-decoration-layout=close,minimize,maximize:
        gtk-enable-animations=1;
        gtk-menu-images=1
        gtk-sound-theme-name=${soundTheme}
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
      gtk-toolbar-style = 3;
    };

    gtk4 = gtk3;
  };

  qt = {
    enable = true;

    style = {
      name = qtStyle;
      package = (
        if globals.standalone
        then null
        else with pkgs; [
          libsForQt5.qtstyleplugin-kvantum
          kdePackages.qtstyleplugin-kvantum
        ]
      );
    };

    kvantum.theme = kvantumTheme;
  };

  programs.plasma.workspace = {
    theme = kdeTheme;
    widgetStyle = qtStyle;
    colorScheme = kvantumTheme;
    soundTheme = soundTheme;
  };

  xdg.configFile = {
    "Kvantum/WhiteSur" = lib.mkIf globals.standalone {
      source = "${kdePackage}/share/Kvantum/WhiteSur";
    };
  };
}
