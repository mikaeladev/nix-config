{
  config,
  globals,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib) optionals;

  inherit (config.xdg) configHome stateHome;
  inherit (config.lib.custom) wrapHome wrapPackage wrapStandaloneBin;

  steamHome = "${stateHome}/steam-home";
  steamApps = "${config.home.homeDirectory}/storage/steam/steamapps";
in

{
  home.packages = [
    (wrapHome {
      newHome = steamHome;
      package = wrapStandaloneBin "${steamApps}/common/Aseprite/aseprite";
    })

    (wrapHome {
      newHome = steamHome;
      package = (
        if globals.standalone then wrapStandaloneBin "/usr/bin/steam" else pkgs.steam
      );
    })
  ]
  ++ optionals globals.standalone [
    (wrapPackage {
      flags."--config" = "${configHome}/nvidia/settings";
      package = wrapStandaloneBin "/usr/bin/nvidia-settings";
    })
  ];

  home.shellAliases = {
    # really useful for when plasmashell panels glitch out
    restart-plasma = "systemctl --user restart plasma-plasmashell";
  };

  xdg.desktopEntries = {
    aseprite = {
      name = "Aseprite";
      comment = "Pixel Art Editor";
      exec = "aseprite %F";
      icon = "steam_icon_431730";
      type = "Application";
      categories = [
        "Graphics"
        "Development"
      ];
    };
  };
}
