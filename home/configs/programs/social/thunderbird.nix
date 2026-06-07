{ config, pkgs, ... }:

let
  inherit (config.lib.custom) wrapGraphics wrapHome;

  tbHome = "${config.xdg.stateHome}/thunderbird-home";
  tbProfiles = "${config.home.homeDirectory}/storage/thunderbird/profiles";
in

{
  home.packages = [
    (wrapHome {
      package = wrapGraphics pkgs.thunderbird;
      newHome = tbHome;
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
      Path=${tbProfiles}/personal
    '';
  };
}
