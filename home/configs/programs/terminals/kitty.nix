{ config, pkgs, ... }:

let
  inherit (config.lib.custom) wrapGraphics;
in

{
  programs.kitty = {
    enable = true;
    package = wrapGraphics pkgs.kitty;

    themeFile = "kanagawabones";

    font = {
      name = "JetBrainsMono Nerd Font";
      size = 12;
    };

    keybindings = {
      "ctrl+c" = "copy_or_interrupt";
      "cmd+c" = "copy_or_interrupt";

      "kitty_mod+v" = "paste_from_clipboard";
      "cmd+v" = "paste_from_clipboard";
    };

    settings = {
      background_blur = 10;
      background_opacity = 0.7;
      enable_audio_bell = false;
      scrollback_lines = 10000;
      update_check_interval = 0;
    };
  };
}
