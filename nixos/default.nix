{
  config,
  globals,
  inputs,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib) mkIf;

  secretsCfg = config.age.secrets;
in

{
  imports = with inputs; [
    # flake modules
    agenix.nixosModules.default
    home-manager.nixosModules.default
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

  nixpkgs.config = {
    allowUnfree = true;
    nvidia.acceptLicense = true;
  };

  system.stateVersion = "25.05";

  age.secrets = mkIf globals.secrets {
    "networks".file = ../secrets/networks.age;
    "passwords/root".file = ../secrets/passwords/root.age;
    "passwords/mainuser".file = ../secrets/passwords/mainuser.age;
  };

  users.users = {
    root = {
      uid = 0;
      shell = pkgs.zsh;
      hashedPasswordFile = mkIf globals.secrets secretsCfg."passwords/root".path;
      initialPassword = "changeme";
    };

    ${globals.mainuser.username} = {
      uid = 1000;
      shell = pkgs.zsh;
      description = globals.mainuser.nickname;
      hashedPasswordFile = mkIf globals.secrets secretsCfg."passwords/mainuser".path;
      initialPassword = "changeme";
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
    extraSpecialArgs = { inherit globals inputs; };

    users = {
      ${globals.mainuser.username} = import ../../home;
    };
  };
}
