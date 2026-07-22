{ config, pkgs, ... }:

let
  inherit (config.lib.self) wrapHome wrapStandaloneBin;
in

{
  home.packages = [
    (wrapHome {
      homePath = config.xdg.stateHome + "/steam-home";
      package =
        if config.globals.standalone then
          wrapStandaloneBin "/usr/bin/steam"
        else
          pkgs.steam;
    })
  ];
}
