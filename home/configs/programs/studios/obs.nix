{ config, pkgs, ... }:

let
  inherit (config.lib.custom) wrapGraphics;
in

{
  programs.obs-studio = {
    enable = true;
    package = wrapGraphics pkgs.obs-studio;
  };
}
