{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (pkgs.stdenv.HostsPlatform) isDarwin;

  inherit (lib)
    mkIf
    mkMerge
    mkOption
    types
    ;

  mozillaCfg = config.mozilla;
  firefoxCfg = config.programs.firefox;
  thunderbirdCfg = config.programs.thunderbird;
  librewolfCfg = config.programs.librewolf;

  oldLinuxMozillaHostsPath = ".mozilla/native-messaging-hosts";

  oldFirefoxHostsPath =
    if isDarwin then
      "Library/Application Support/Mozilla/NativeMessagingHosts"
    else
      oldLinuxMozillaHostsPath;

  oldThunderbirdHostsPath =
    if isDarwin then
      "Library/Thunderbird/NativeMessagingHosts"
    else
      oldLinuxMozillaHostsPath;

  oldLibrewolfHostsPath =
    if isDarwin then
      "Library/Application Support/LibreWolf/NativeMessagingHosts"
    else
      ".librewolf/native-messaging-hosts";

  newFirefoxHostsPath = firefoxCfg.nativeMessagingHostsPath;
  newThunderbirdHostsPath = thunderbirdCfg.nativeMessagingHostsPath;
  newLibrewolfHostsPath = librewolfCfg.nativeMessagingHostsPath;

  newLinuxMozillaHostsPath =
    if
      (
        firefoxCfg.enable
        && thunderbirdCfg.enable
        && newFirefoxHostsPath != newThunderbirdHostsPath
      )
    then
      throw "Firefox and Thunderbird must have the same messaging host path on Linux"
    else if firefoxCfg.enable then
      newFirefoxHostsPath
    else
      newThunderbirdHostsPath;

  redirectDirectory = oldPath: newPath: {
    "${oldPath}".enable = false;
    "${newPath}" = {
      source = config.home.file."${oldPath}".source;
      recursive = true;
      force = true;
    };
  };

  darwinFirefoxDirectory = (
    mkIf (
      mozillaCfg.firefoxNativeMessagingHosts != [ ]
      && oldFirefoxHostsPath != newFirefoxHostsPath
    ) (redirectDirectory "${oldFirefoxHostsPath}" "${newFirefoxHostsPath}")
  );

  darwinThunderbirdDirectory = (
    mkIf (
      mozillaCfg.thunderbirdNativeMessagingHosts != [ ]
      && oldThunderbirdHostsPath != newThunderbirdHostsPath
    ) (redirectDirectory "${oldThunderbirdHostsPath}" "${newThunderbirdHostsPath}")
  );

  linuxMozillaDirectory = (
    mkIf
      (
        (
          mozillaCfg.firefoxNativeMessagingHosts != [ ]
          || mozillaCfg.thunderbirdNativeMessagingHosts != [ ]
        )
        && (
          (firefoxCfg.enable && oldFirefoxHostsPath != newFirefoxHostsPath)
          || thunderbirdCfg.enable && oldThunderbirdHostsPath != newThunderbirdHostsPath
        )
      )
      (redirectDirectory "${oldLinuxMozillaHostsPath}" "${newLinuxMozillaHostsPath}")
  );

  librewolfDirectory = (
    mkIf (
      mozillaCfg.librewolfNativeMessagingHosts != [ ]
      && oldLibrewolfHostsPath != newLibrewolfHostsPath
    ) (redirectDirectory "${oldLibrewolfHostsPath}" "${newLibrewolfHostsPath}")
  );

  mkDescription = appName: ''
    The path to the ${appName} messaging hosts directory. This option does
    not change where ${appName} looks for messaging hosts, only where
    home-manager files are placed. Only change if you have a nonstandard
    installation, such as when overriding $HOME in a wrapped package.
  '';
in

{
  options.programs = {
    firefox.nativeMessagingHostsPath = mkOption {
      type = types.str;
      default = oldFirefoxHostsPath;
      description = mkDescription "Firefox";
    };

    thunderbird.nativeMessagingHostsPath = mkOption {
      type = types.str;
      default = oldThunderbirdHostsPath;
      description = mkDescription "Thunderbird";
    };

    librewolf.nativeMessagingHostsPath = mkOption {
      type = types.str;
      default = oldLibrewolfHostsPath;
      description = mkDescription "Librewolf";
    };
  };

  config.home.file =
    mkIf (firefoxCfg.enable || thunderbirdCfg.enable || librewolfCfg.enable)
      (
        mkMerge (
          if isDarwin then
            [
              darwinFirefoxDirectory
              darwinThunderbirdDirectory
              librewolfDirectory
            ]
          else
            [
              linuxMozillaDirectory
              librewolfDirectory
            ]
        )
      );
}
