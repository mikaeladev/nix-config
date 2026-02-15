{
  config,
  inputs,
  pkgs,
  ...
}:

let
  inherit (config.lib.custom) wrapGraphics;

  zenProfiles = "${config.home.homeDirectory}/storage/zen/profiles";
  zenPackage = inputs.zen-browser.packages.${pkgs.stdenv.system}.beta;
in

{
  imports = [ inputs.zen-browser.homeModules.beta ];

  programs.zen-browser = {
    enable = true;
    package = wrapGraphics zenPackage;
    profiles = { };
  };

  xdg.configFile = {
    "zen/profiles.ini".text = ''
      [Profile1]
      IsRelative=0
      Name=private
      Path=${zenProfiles}/private

      [Profile0]
      IsRelative=0
      Name=home
      Path=${zenProfiles}/home
      Default=1

      [General]
      StartWithLastProfile=1
      Version=2

      [Install0]
      Default=${zenProfiles}/home
      Locked=1
    '';

    "zen/installs.ini".text = ''
      [0]
      Default=${zenProfiles}/home
      Locked=1
    '';
  };
}
