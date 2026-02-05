{
  config,
  lib,
  pkgs-stable,
  ...
}:

let
  inherit (config.lib.custom) wrapGraphics;

  storageDrive = "${config.home.homeDirectory}/storage";
  prismStorage = "${storageDrive}/prism";
in

{
  programs.prismlauncher = {
    enable = true;
    package = wrapGraphics pkgs-stable.prismlauncher;

    icons = [
      ./assets/fabulously-optimised.png
      ./assets/java.png
    ];

    settings = {
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
}
