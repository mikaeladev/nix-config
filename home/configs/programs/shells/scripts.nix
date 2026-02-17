{
  config,
  globals,
  pkgs,
  ...
}:

let
  inherit (config.xdg) stateHome;
  inherit (config.lib.custom) wrapHome wrapStandaloneBin;

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
  ];

  home.shellAliases = rec {
    # really useful for when plasmashell panels glitch out
    restart-plasma = "systemctl --user restart plasma-plasmashell";

    home-rebuild = "NIXPKGS_ALLOW_UNFREE=1 home-manager switch --impure";
    home-rollback = "${home-rebuild} --rollback";
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
