{ config, globals, pkgs, ... }:

{
  programs.obs-studio = {
    enable = true;

    package = (
      if globals.standalone
      then (config.lib.nixGL.wrap pkgs.obs-studio)
      else pkgs.obs-studio
    );
  };
}
