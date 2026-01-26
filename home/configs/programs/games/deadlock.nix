{ config, pkgs, ... }:

let
  inherit (config.lib.custom) wrapGraphics wrapHome;
  inherit (config.xdg) stateHome;

  steamHome = "${stateHome}/steam-home";
in

{
  programs.deadlock-mod-manager = {
    enable = true;

    package = wrapHome {
      package = wrapGraphics pkgs.deadlock-mod-manager;
      newHome = steamHome;
    };
  };
}
