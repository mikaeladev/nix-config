{ pkgs, ... }:

{
  fonts.fontconfig = {
    enable = true;
    antialiasing = true;
    subpixelRendering = "none";
    hinting = "slight";

    defaultFonts = {
      serif = [ "SF Pro" ];
      sansSerif = [ "SF Pro" ];
      monospace = [ "JetBrains Mono" ];
      emoji = [ "Apple Color Emoji" ];
    };
  };

  home.packages = with pkgs; [
    # sans-serif fonts
    apple-sf-pro

    # monospace fonts
    jetbrains-mono
    nerd-fonts.jetbrains-mono

    # emoji fonts
    apple-color-emoji
  ];
}
