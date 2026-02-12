{ pkgs, ... }:

let
  iconTheme = "WhiteSur-dark";
  iconPackage = pkgs.whitesur-icon-theme;

  cursorTheme = "pixel-cursors-default";
  cursorPackage = pkgs.pixel-cursors;
  cursorSize = 24;
in

{
  home.packages = [
    iconPackage
    cursorPackage
  ];

  gtk.iconTheme.name = iconTheme;

  programs.plasma.workspace = {
    inherit iconTheme;

    cursor = {
      theme = cursorTheme;
      size = cursorSize;
    };
  };

  home.pointerCursor = {
    enable = true;
    gtk.enable = true;
    dotIcons.enable = false;
    name = cursorTheme;
    package = cursorPackage;
    size = cursorSize;
  };

  xdg.dataFile."./icons/${cursorTheme}".source =
    "${cursorPackage}/share/icons/${cursorTheme}";
}
