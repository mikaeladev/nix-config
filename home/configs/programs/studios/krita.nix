{ config, pkgs, ... }:

let
  inherit (config.lib.custom) wrapGraphics;
in

{
  programs.krita = {
    enable = true;
    package = wrapGraphics pkgs.krita;
  };
}
