{
  config,
  globals,
  lib,
  ...
}:

let
  inherit (lib) isAttrs mkIf;
  inherit (config.lib.custom) wrapHome wrapStandaloneBin;
in

{
  config = mkIf (isAttrs globals.storageDevice) {
    home.packages = [
      (wrapHome {
        newHome = "${config.xdg.stateHome}/steam-home";
        package = wrapStandaloneBin "${globals.storageDevice.mountPoint}/steam/steamapps/common/Aseprite/aseprite";
      })
    ];

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
  };
}
