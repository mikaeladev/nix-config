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

      env = {
        WEBKIT_DISABLE_COMPOSITING_MODE = true;
      };
    };
  };
}
