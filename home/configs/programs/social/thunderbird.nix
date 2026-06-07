{
  config,
  globals,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib) isAttrs mkIf;
  inherit (config.lib.custom) wrapGraphics wrapHome;
in

{
  config = mkIf (isAttrs globals.storage) {
    home.packages = [
      (wrapHome {
        package = wrapGraphics pkgs.thunderbird;
        newHome = "${config.xdg.stateHome}/thunderbird-home";
      })
    ];

    xdg.stateFile = {
      "thunderbird-home/.thunderbird/profiles.ini".text = ''
        [General]
        StartWithLastProfile=1
        Version=2

        [Profile0]
        Default=1
        IsRelative=0
        Name=personal
        Path=${globals.storage.mountPoint}/thunderbird/profiles/personal
      '';
    };
  };
}
