{ pkgs, ... }:

rec {
  home.pointerCursor = {
    enable = true;
    gtk.enable = true;
    dotIcons.enable = false;

    name = "pixel-cursors-default";
    package = pkgs.pixel-cursors;
    size = 24;
  };

  xdg.dataFile."./icons/${home.pointerCursor.name}".source =
    "${pkgs.pixel-cursors}/share/icons/${home.pointerCursor.name}";
}
