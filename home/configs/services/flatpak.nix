{ globals, inputs, lib, ... }:

{
  imports = [ inputs.flatpaks.homeManagerModules.nix-flatpak ];

  services.flatpak = {
    enable = true;

    update.auto = {
      enable = true;
      onCalendar = "weekly";
    };

    packages = [
      "app.zen_browser.zen"
      "eu.betterbird.Betterbird"
    ] ++ lib.optionals globals.standalone [
      "com.vysp3r.ProtonPlus"
    ];
  };
}
