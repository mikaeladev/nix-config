{ config, inputs, ... }:

let
  fontName = config.gtk.font.name;
  fontSize = config.gtk.font.size;

  defaultFont = {
    family = fontName;
    pointSize = fontSize;
  };
in

{
  imports = [ inputs.plasma-manager.homeModules.plasma-manager ];

  programs.plasma = {
    enable = true;

    fonts = {
      menu = defaultFont;
      windowTitle = defaultFont;
      general = defaultFont;
      fixedWidth = {
        family = "JetBrains Mono";
        pointSize = fontSize;
      };
      small = {
        family = fontName;
        pointSize = (fontSize - 2);
      };
      toolbar = {
        family = fontName;
        pointSize = (fontSize - 1);
      };
    };

    kwin = {
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

      titlebarButtons.left = [
        "close"
        "minimize"
        "maximize"
      ];
    };

    configFile.kwinrc.Plugins = {
      screenedgeEnabled = false;
      sheetEnabled = true;
    };

    workspace.windowDecorations = {
      library = "org.kde.kwin.aurorae";
      theme = "__aurorae__svg__WhiteSur-dark";
    };

    workspace = {
      wallpaper = "${config.xdg.dataHome}/wallpapers/current.png";
      widgetStyle = config.qt.style.name;
      colorScheme = config.qt.kvantum.theme.name;
      iconTheme = config.gtk.iconTheme.name;
      soundTheme = config.gtk.gtk4.extraConfig.gtk-sound-theme-name;
      cursor = {
        theme = config.home.pointerCursor.name;
        size = config.home.pointerCursor.size;
      };
    };
  };

  xdg.dataFile."wallpapers/current.png" = {
    source = ./wallpaper.png;
  };
}
