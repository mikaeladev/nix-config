{
  config,
  globals,
  pkgs,
  ...
}:

let
  inherit (globals.lib) patchDesktopFileExec;
in

{
  programs.vesktop = {
    enable = true;

    package = (
      if globals.standalone
      then (config.lib.nixGL.wrap pkgs.vesktop)
      else pkgs.vesktop
    );

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
      themes = {
        "system24" = ./themes/system24.css;
      };

      settings = {
        autoUpdate = false;
        autoUpdateNotification = false;
        notifyAboutUpdates = false;

        useQuickCss = true;
        enableReactDevtools = true;
        disableMinSize = true;
        winCtrlQ = true;

        enabledThemes = [
          "system24.css"
        ];

        plugins = builtins.fromJSON (builtins.readFile ./settings/plugins.json);

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

  xdg.configFile."./vesktop/settings/quickCss.css" = {
    source = builtins.toString ./settings/quick.css;
  };

  xdg.autostart.entries = [
    (patchDesktopFileExec "vesktop" "${config.home.profileDirectory}/bin/vesktop"
      "${pkgs.vesktop}/share/applications/vesktop.desktop")
  ];
}
