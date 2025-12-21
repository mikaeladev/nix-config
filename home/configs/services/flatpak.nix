{ inputs, ... }:

{
  imports = [ inputs.flatpaks.homeManagerModules.nix-flatpak ];

  services.flatpak = {
    enable = true;

    update.auto = {
      enable = true;
      onCalendar = "weekly";
    };

    packages = [
      "eu.betterbird.Betterbird"
    ];
  };
}
