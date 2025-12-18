{ config, pkgs, ... }:

{
  home.packages = [
    pkgs.whitesur-kde
  ];

  programs.plasma.workspace = {
    wallpaper = "${config.xdg.dataHome}/wallpapers/current.png";

    theme = "WhiteSur-dark";
    iconTheme = config.gtk.iconTheme.name;
    colorScheme = config.programs.kvantum.theme.name;
    widgetStyle = config.qt.style.name;
    soundTheme = "ocean";

    cursor = {
      theme = config.gtk.cursorTheme.name;
      size = config.gtk.cursorTheme.size;
    };

    windowDecorations = {
      library = "org.kde.kwin.aurorae";
      theme = "__aurorae__svg__WhiteSur-dark";
    };
  };

  xdg.dataFile."./wallpapers/current.png" = {
    source = ./assets/wallpaper.png;
  };
}
