{ config, lib, ... }:

let
  inherit (lib) mkIf;
  inherit (config.lib.self) wrapHome wrapStandaloneBin;
in

{
  config = mkIf config.globals.storage.enable {
    home.packages = [
      (wrapHome {
        homePath = config.xdg.stateHome + "/steam-home";
        package = wrapStandaloneBin (
          config.globals.storage.mountPoint + "/steam/steamapps/common/Aseprite/aseprite"
        );
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
