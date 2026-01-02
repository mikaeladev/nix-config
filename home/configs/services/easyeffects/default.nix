{ config, pkgs, ... }:

let
  inherit (config.lib.custom) wrapGraphics;
in


{
  services.easyeffects = {
    enable = true;
    package = wrapGraphics pkgs.easyeffects;
    preset = "perfect eq + bass boost";
  };

  xdg.configFile."./easyeffects/output" = {
    source = builtins.toString ./presets/output;
  };
}
