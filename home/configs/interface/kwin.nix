{ ... }:

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
  };
}
