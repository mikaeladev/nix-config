{ config, globals, pkgs, ... }:

{
  programs.prism-launcher = {
    enable = true;

    package = (
      if globals.standalone
      then (config.lib.nixGL.wrap pkgs.prismlauncher)
      else pkgs.prismlauncher
    );
  };
}
