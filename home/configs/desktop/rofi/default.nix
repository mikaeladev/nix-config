{ config, lib, ... }:

let
  inherit (lib) getExe;
in

{
  programs.rofi = {
    enable = true;
    theme = ./theme.rasi;
    settings = {
      cycle = false;
      modes = [ "drun" ];
      terminal = getExe config.programs.kitty.package;
    };
  };
}
