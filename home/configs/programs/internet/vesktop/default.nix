{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib) fromJSON readFile;
  inherit (config.lib.self) patchDesktopItemExec;
in

{
  programs.vesktop = {
    enable = true;

    settings = {
      discordBranch = "stable";

      arRPC = true;
      appBadge = true;
      checkUpdates = false;
      customTitleBar = false;
      disableMinSize = true;

      hardwareAcceleration = true;
      hardwareVideoAcceleration = true;

      enableSplashScreen = true;
      splashTheming = true;

      minimizeToTray = true;
      clickTrayToShowHide = true;
      autoStartMinimized = true;

      spellCheckLanguages = [
        "en-GB"
        "en"
      ];
    };

    vencord = {
      themes."system24" = ./theme.css;

      settings = {
        autoUpdate = false;
        autoUpdateNotification = false;
        notifyAboutUpdates = false;

        enableReactDevtools = true;
        disableMinSize = true;
        winCtrlQ = true;

        useQuickCss = false;
        enabledThemes = [ "system24.css" ];

        plugins = fromJSON (readFile ./plugins.json);

        notifications = {
          timeout = 5000;
          position = "bottom-right";
          useNative = "always";
          logLimit = 50;
        };

        cloud = {
          authenticated = false;
          settingsSync = false;
          settingsSyncVersion = 0;
          url = "https://api.vencord.dev/";
        };
      };
    };
  };

  xdg.autostart.entries = [
    (patchDesktopItemExec (pkgs.vesktop + "/share/applications/vesktop.desktop") (
      config.home.profileDirectory + "/bin/vesktop"
    ))
  ];
}
