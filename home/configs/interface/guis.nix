{
  config,
  globals,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib) mkMerge;
in

mkMerge [
  {
    gtk = rec {
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

      gtk2 = {
        configLocation = "${config.xdg.configHome}/gtk-2.0/gtkrc";
        extraConfig = ''
          gtk-button-images=1
          gtk-cursor-blink=1;
          gtk-cursor-blink-time=1000;
          gtk-decoration-layout=close,minimize,maximize:
          gtk-enable-animations=1;
          gtk-menu-images=1
          gtk-sound-theme-name=ocean
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
        gtk-sound-theme-name = "ocean";
        gtk-toolbar-style = 3;
      };

      gtk4 = gtk3;
    };

    programs.kvantum = {
      enable = true;

      theme = {
        name = "WhiteSurDark";
        package = pkgs.whitesur-kde;
      };
    };

    qt = {
      enable = true;
      style.name = "kvantum-dark";
    };
  }

  # overrides for non-nixos / kde quirks
  (if globals.standalone then {
    programs.kvantum.package = null;
    qt.style.package = null;

    xdg.configFile."./Kvantum/WhiteSur".source =
      "${config.home.profileDirectory}/share/Kvantum/WhiteSur";
  } else {})
]
