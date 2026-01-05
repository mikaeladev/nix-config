{ config, globals, lib, pkgs, ... }:

let
  inherit (globals.mainuser.xdg) stateHome;

  inherit (config.lib.custom)
    wrapGraphics
    wrapHome
    mkThunderbirdAddon
    ;

  thunderbirdHome = "${stateHome}/thunderbird-home";

  minimizeOnClose = mkThunderbirdAddon {
    name = "minimize-on-close";
    version = "2.0.2.0-unsupported";
    addonId = "minimize-on-close@rsjtdrjgfuzkfg.github.com";
    url = "https://github.com/rsjtdrjgfuzkfg/thunderbird-minimizeonclose/releases/download/v2.0.2.0/minimizeonclose-unsupported.xpi";
    sha256 = "sha256-AwOGVT0xzNPmKYxYKvDdDzqUK8lqbR+FH2KmKkZYvvo=";
    meta = with lib; {
      homepage = "https://github.com/rsjtdrjgfuzkfg/thunderbird-minimizeonclose";
      description = "Minimizes Thunderbird's main window when clicking on the close button";
      license = licenses.mpl20;
      platforms = platforms.all;
    };
  };

  simpleStartupMinimizer = mkThunderbirdAddon {
    name = "simple-startup-minimize";
    version = "0.6.0";
    addonId = "simple-startup-minimize@farahats9.github.com";
    url = "https://github.com/farahats9/simple-startup-minimizer/releases/download/v0.6/Simple.Startup.Minimizer.xpi";
    sha256 = "sha256-oWuzyFoR8bikZrPSXMnQ2AOYAC4MQnWtKIK7rnyf+HM=";
    meta = with lib; {
      homepage = "https://github.com/farahats9/simple-startup-minimizer";
      description = "Minimizes Thunderbird's main window on startup";
      platforms = platforms.all;
    };
  };
in

{
  programs.thunderbird = {
    enable = false; # leave disabled until config is complete

    configPath = "${thunderbirdHome}/.thunderbird";

    package = wrapGraphics (wrapHome {
      package = pkgs.thunderbird;
      newHome = thunderbirdHome;
    });

    profiles.personal = {
      isDefault = true;
      extensions = [
        minimizeOnClose
        simpleStartupMinimizer
      ];
    };
  };
}
