{ pkgs, ... }:

let
  generalFont = "SF Pro";
  monospaceFont = "JetBrains Mono";
  fontSize = 10;
in

{
  home.packages = [
    # general fonts
    pkgs.apple-fonts.sf-pro

    # monospace fonts
    pkgs.jetbrains-mono
    pkgs.nerd-fonts.jetbrains-mono

    # emoji fonts
    pkgs.apple-fonts.emoji
  ];

  fonts.fontconfig = {
    enable = true;
    antialiasing = true;
    subpixelRendering = "none";
    hinting = "slight";

    defaultFonts = {
      serif = [
        generalFont
        "serif"
      ];
      sansSerif = [
        generalFont
        "sans-serif"
      ];
      monospace = [
        monospaceFont
        "monospace"
      ];
    };
  };

  gtk.font = {
    name = generalFont;
    size = fontSize;
    package = pkgs.apple-fonts.sf-pro;
  };

  programs.plasma.fonts = rec {
    general = {
      family = generalFont;
      pointSize = fontSize;
    };
    fixedWidth = {
      family = monospaceFont;
      pointSize = fontSize;
    };
    small = {
      family = generalFont;
      pointSize = (fontSize - 2);
    };
    toolbar = {
      family = generalFont;
      pointSize = (fontSize - 1);
    };
    menu = general;
    windowTitle = general;
  };
}
