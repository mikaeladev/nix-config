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
    
    theme = {
      icons = "flat_white";
      widgets = "dark";
      cat = "rory";
    };

    icons = [
      ./assets/fabulously-optimised.png
      ./assets/java.png
    ];
  };
}
