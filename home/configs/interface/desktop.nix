{ config, ... }:

let
  wallpaperPath = "${config.xdg.dataHome}/wallpapers/current.png";

  # spacer = {
  #   panelSpacer = {
  #     settings.General.expanding = true;
  #   };
  # };

  # separator = {
  #   name = "zayron.simple.separator"; # todo: add this to pkgs
  #   config = {
  #     General = {
  #       opacity = 30;
  #       thicknessSeparator = 2;
  #     };
  #   };
  # };
in

{
  # programs.plasma = {
  #   panels = [
  #     {
  #       height = 32;
  #       hiding = "dodgewindows";
  #       lengthMode = "fill";
  #       location = "top";
  #       opacity = "translucent";
  #       screen = "all";

  #       widgets = [
  #         {
  #           name = "org.kde.plasma.weather";
  #           config = {
  #             Appearance.showTemperatureInCompactMode = true;
  #             Appearance.showWindInTooltip = false;
  #             Units.temperatureUnit = 6001;
  #           };
  #         }
  #         spacer
  #         {
  #           digitalClock = {
  #             date = {
  #               enable = true;
  #               format = "longDate";
  #               position = "besideTime";
  #             };
  #             font = {
  #               family = "SF Pro";
  #               size = 12;
  #               style = "Regular";
  #               weight = 400;
  #             };
  #             time = {
  #               showSeconds = "never";
  #               format = "24h";
  #             };
  #           };
  #         }
  #         spacer
  #         {
  #           systemTray = {
  #             items.hidden = [
  #               "easyeffects"
  #               "org.kde.plasma.bluetooth"
  #               "org.kde.plasma.brightness"
  #               "org.kde.plasma.clipboard"
  #               "org.kde.plasma.diskquota"
  #               "org.kde.plasma.mediacontroller"
  #               "org.kde.plasma.trash"
  #               "org.kde.plasma.volume"
  #             ];
  #           };
  #         }
  #       ];
  #     }
  #     {
  #       height = 48;
  #       hiding = "dodgewindows";
  #       lengthMode = "fit";
  #       location = "bottom";
  #       opacity = "translucent";
  #       screen = "all";

  #       widgets = [
  #         {
  #           kickerdash = {
  #             icon = "homerun";
  #           };
  #         }
  #         separator
  #         {
  #           iconTasks = {
  #             appearance = {
  #               iconSpacing = "small";
  #               indicateAudioStreams = false;
  #             };
  #             launchers = [
  #               "applications:zen-beta.desktop"
  #               "applications:dev.zed.Zed.desktop"
  #               "applications:vesktop.desktop"
  #               "applications:steam.desktop"
  #               "applications:spotify.desktop"
  #             ];
  #           };
  #         }
  #       ];
  #     }
  #   ];

  #   workspace.wallpaper = wallpaperPath;
  # };

  home.file.${wallpaperPath} = {
    source = ./assets/wallpaper.png;
  };
}
