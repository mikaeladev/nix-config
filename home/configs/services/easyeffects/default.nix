{ config, globals, pkgs, ... }:

{
  services.easyeffects = {
    enable = true;

    package = (
      if globals.standalone
      then (config.lib.nixGL.wrap pkgs.easyeffects)
      else pkgs.easyeffects
    );

    preset = "perfect eq + bass boost";
  };

  xdg.configFile."./easyeffects/output" = {
    source = builtins.toString ./presets/output;
  };
}
