{ config, pkgs, ... }:

let
  inherit (config.lib.custom) wrapGraphics;
in

{
  programs.deadlock-mod-manager = {
    enable = true;
    package = wrapGraphics pkgs.deadlock-mod-manager;
  };
}
