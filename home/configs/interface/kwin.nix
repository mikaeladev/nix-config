{ config, ... }:

{
  programs.plasma = {
    kwin = {
      titlebarButtons.left = [
        "close"
        "minimize"
        "maximize"
      ];

      effects = {
        minimization.animation = "magiclamp";
        dimAdminMode.enable = true;
        translucency.enable = true;
        wobblyWindows.enable = true;

        blur = {
          enable = true;
          strength = 9;
          noiseStrength = 4;
        };
      };

      virtualDesktops = {
        names = [ "Default" ];
        rows = 1;
      };
    };

    configFile.kwinrc.Plugins = {
      screenedgeEnabled = false;
      sheetEnabled = true;
    };

    workspace = {
      wallpaper = "${config.xdg.dataHome}/wallpapers/current.png";

      windowDecorations = {
        library = "org.kde.kwin.aurorae";
        theme = "__aurorae__svg__WhiteSur-dark";
      };
    };
  };

  xdg.dataFile."./wallpapers/current.png" = {
    source = ./assets/wallpaper.png;
  };
}
