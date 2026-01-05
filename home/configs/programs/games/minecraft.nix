{ config, inputs, pkgs, ... }:

let
  inherit (config.lib.custom) wrapGraphics;
in

{
  imports = [
    inputs.prismlauncher.homeModules.default
  ];

  programs.prismlauncher = {
    enable = true;
    package = wrapGraphics pkgs.prismlauncher;
  };
}
