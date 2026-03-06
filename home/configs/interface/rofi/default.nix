{ config, lib, ... }:

let
  inherit (lib) getExe;
in

{
  programs.rofi = {
    enable = true;
    cycle = false;
    modes = [ "drun" ];
    terminal = getExe config.programs.kitty.package;
    theme = ./theme.rasi;
  };
}
