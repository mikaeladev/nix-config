{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib) getExe;
  inherit (pkgs) writeShellScriptBin;
in

{
  programs.rofi = {
    enable = true;
    cycle = false;
    modes = [ "drun" ];
    terminal = getExe config.programs.kitty.package;
    theme = ./theme.rasi;
  };

  home.packages = [
    (writeShellScriptBin "toggle-rofi-launcher" ''
      PID=$(pgrep -x rofi)

      if [ $PID ]; then
        kill $PID
      else
        rofi -show drun
      fi
    '')
  ];
}
