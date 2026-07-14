{
  config,
  globals,
  pkgs,
  ...
}:

let
  inherit (config.xdg) stateHome;
  inherit (config.lib.self) wrapHome wrapStandaloneBin;
in

{
  home.packages = [
    (wrapHome {
      homePath = "${stateHome}/steam-home";
      package =
        if globals.standalone then wrapStandaloneBin "/usr/bin/steam" else pkgs.steam;
    })
  ];
}
