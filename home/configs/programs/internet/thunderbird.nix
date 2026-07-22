{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib) mkIf;
  inherit (config.lib.self) wrapHome;
in

{
  config = mkIf config.globals.storage.enable {
    home.packages = [ (wrapHome { package = pkgs.thunderbird; }) ];

    xdg.stateFile = {
      "thunderbird-home/.thunderbird/profiles.ini".text = ''
        [General]
        StartWithLastProfile=1
        Version=2

        [Profile0]
        Default=1
        IsRelative=0
        Name=personal
        Path=${config.globals.storage.mountPoint}/thunderbird/profiles/personal
      '';
    };
  };
}
