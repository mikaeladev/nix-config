{ config, pkgs, ... }:

let
  cfg = config.home.pointerCursor;
in

{
  home.pointerCursor = {
    enable = true;
    gtk.enable = true;
    dotIcons.enable = false;

    name = "pixel-cursors-default";
    package = pkgs.pixel-cursors;
    size = 24;
  };

  xdg.dataFile."./icons/${cfg.name}".source =
    "${config.home.profileDirectory}/share/icons/${cfg.name}";
}
