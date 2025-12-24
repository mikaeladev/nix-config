{ inputs, ... }:

{
  imports = [
    inputs.agenix.nixosModules.default
    inputs.home-manager.nixosModules.default
    ./hardware.nix
    ./configs
  ];

  age.secrets = {
    "networks".file = ../secrets/networks.age;
    "passwords/root".file = ../passwords/root.age;
    "passwords/mainuser".file = ../passwords/mainuser.age;
  };

  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];

    trusted-users = [
      "root"
      "@wheel"
    ];
  };

  system.stateVersion = "25.05";
}
