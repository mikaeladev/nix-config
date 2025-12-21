{ inputs, ... }:

let
  inherit (inputs) agenix home-manager;
in

{
  imports = [
    agenix.nixosModules.default
    home-manager.nixosModules.default
    ./hardware.nix
    ./configs
  ];

  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    trusted-users = [ "root" "@wheel" ];
  };

  system.stateVersion = "25.05";
}
