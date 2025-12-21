{ config, globals, inputs, pkgs, ... }:

let
  profilesDir = "${config.home.homeDirectory}/storage/zen/profiles";
  zenPackage = inputs.zen-browser.packages.${pkgs.stdenv.system}.beta;
in

{
  imports = [
    inputs.zen-browser.homeModules.beta
  ];

  programs.zen-browser = {
    enable = true;

    package = (
      if globals.standalone
      then (config.lib.nixGL.wrap zenPackage)
      else zenPackage
    );

    profiles = {};
  };

  home.file = {
    ".zen/profiles.ini".text = ''
      [Profile1]
      IsRelative=0
      Name=private
      Path=${profilesDir}/private

      [Profile0]
      IsRelative=0
      Name=home
      Path=${profilesDir}/home
      Default=1

      [General]
      StartWithLastProfile=1
      Version=2

      [Install0]
      Default=${profilesDir}/home
      Locked=1
    '';

    ".zen/installs.ini".text = ''
      [0]
      Default=${profilesDir}/home
      Locked=1
    '';
  };
}
