{
  config,
  globals,
  inputs,
  pkgs,
  ...
}:

{
  imports = [
    # flake modules
    inputs.agenix.nixosModules.default
    inputs.home-manager.nixosModules.default
    # local modules
    ./boot.nix
    ./environment.nix
    ./hardware.nix
    ./networks.nix
  ];

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

  age.secrets = {
    "networks".file = ../secrets/networks.age;
    "passwords/root".file = ../secrets/passwords/root.age;
    "passwords/mainuser".file = ../secrets/passwords/mainuser.age;
  };

  users.users = {
    root = {
      uid = 0;
      shell = pkgs.zsh;
      hashedPasswordFile = config.age.secrets."passwords/root".path;
    };

    ${globals.mainuser.username} = {
      uid = 1000;
      shell = pkgs.zsh;
      description = globals.mainuser.nickname;
      hashedPasswordFile = config.age.secrets."passwords/mainuser".path;
      extraGroups = [
        "networkmanager"
        "wheel"
      ];
    };
  };

  home-manager = {
    useGlobalPkgs = false;
    useUserPackages = true;
    backupFileExtension = "backup";
    extraSpecialArgs = { inherit globals inputs pkgs; };

    users = {
      ${globals.mainuser.username} = import ../../home;
    };
  };
}
