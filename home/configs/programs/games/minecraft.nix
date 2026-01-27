{
  config,
  inputs,
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
  imports = [ inputs.prismlauncher.homeModules.default ];

  programs.prismlauncher = {
    enable = true;
    package = wrapGraphics pkgs-stable.prismlauncher;

    icons = [
      ./assets/fabulously-optimised.png
      ./assets/java.png
    ];

    theme = {
      icons = "flat_white";
      widgets = "dark";
      cat = "rory";
    };

    settings = {
      CloseAfterLaunch = true;

      ConsoleFont = lib.head config.fonts.fontconfig.defaultFonts.monospace;
      ConsoleFontSize = 10;
      ConsoleMaxLines = 10000;

      DownloadsDir = config.xdg.userDirs.download;
      CentralModsDir = "${prismStorage}/mods";
      InstanceDir = "${prismStorage}/instances";
      SkinsDir = "${prismStorage}/skins";
      JavaDir = "java";

      NumberOfConcurrentDownloads = 12;
      NumberOfConcurrentTasks = 16;
      RequestTimeout = 30;

      MaxMemAlloc = 1024 * 16;
    };
  };
}
