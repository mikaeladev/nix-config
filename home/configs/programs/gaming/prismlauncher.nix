{
  config,
  globals,
  lib,
  ...
}:

let
  inherit (lib) isAttrs mkIf;
in

{
  config = mkIf (isAttrs globals.storageDevice) {
    programs.prismlauncher = {
      enable = true;

      icons = [
        ./assets/fabulously-optimised.png
        ./assets/java.png
      ];

      settings =
        let
          prismStorage = "${globals.storageDevice.mountPoint}/prism";
        in
        {
          CloseAfterLaunch = true;

          ConsoleFont = lib.head config.fonts.fontconfig.defaultFonts.monospace;
          ConsoleFontSize = 10;
          ConsoleMaxLines = 10000;

          ApplicationTheme = "dark";
          BackgroundCat = "rory";
          IconTheme = "flat_white";

          DownloadsDir = config.xdg.userDirs.download;
          CentralModsDir = "${prismStorage}/mods";
          InstanceDir = "${prismStorage}/instances";
          SkinsDir = "${prismStorage}/skins";
          IconsDir = "icons";
          JavaDir = "java";

          NumberOfConcurrentDownloads = 12;
          NumberOfConcurrentTasks = 16;
          RequestTimeout = 30;

          MaxMemAlloc = 1024 * 16;
        };
    };
  };
}
