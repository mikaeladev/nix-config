{ config, globals, pkgs, ... }:

{
  programs.deadlock-mod-manager = {
    enable = true;

    package = (
      if globals.standalone
      then (config.lib.nixGL.wrap pkgs.deadlock-mod-manager)
      else pkgs.deadlock-mod-manager
    );
  };
}
