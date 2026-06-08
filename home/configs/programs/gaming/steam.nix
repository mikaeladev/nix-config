{
  config,
  globals,
  pkgs,
  ...
}:

let
  inherit (config.xdg) stateHome;
  inherit (config.lib.custom) wrapHome wrapStandaloneBin;
in

{
  home.packages = [
    (wrapHome {
      newHome = "${stateHome}/steam-home";
      package =
        if globals.standalone then wrapStandaloneBin "/usr/bin/steam" else pkgs.steam;
    })
  ];
}
