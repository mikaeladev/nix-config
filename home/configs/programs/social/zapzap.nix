{ config, pkgs, ... }:

let
  inherit (config.lib.custom)
    updateDesktopFileValue
    wrapGraphics
    ;
in

{
  programs.zapzap = {
    enable = true;

    package = wrapGraphics pkgs.zapzap;

    settings = {
      notification.donation_message = true;
      website.open_page = false;

      system = {
        wayland = true;

        # ui and theme
        menubar = false;
        sidebar = false;
        theme = "dark";
        tray_theme = "symbolic_light";

        # start with system as minimised
        start_system = true;
        start_background = true;
      };
    };
  };

  xdg.autostart.entries = [
    (updateDesktopFileValue {
      key = "Exec";
      value = "${config.home.profileDirectory}/bin/zapzap";
      source = "${pkgs.zapzap}/share/applications/com.rtosta.zapzap.desktop";
    })
  ];
}
