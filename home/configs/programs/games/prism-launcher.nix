{ config, pkgs, ... }:

let
  inherit (config.lib.custom) wrapGraphics;
in

{
  programs.prism-launcher = {
    enable = true;
    package = wrapGraphics pkgs.prismlauncher;
  };
}
