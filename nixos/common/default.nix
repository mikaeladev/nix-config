{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib) mkIf;

  secretsEnabled = config.globals.secrets;
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

  age.secrets = mkIf secretsEnabled {
    "networks".file = ../../secrets/networks.age;
    "passwords/root".file = ../../secrets/passwords/root.age;
    "passwords/mainuser".file = ../../secrets/passwords/mainuser.age;
  };

  users.users = {
    root = {
      uid = 0;
      shell = pkgs.zsh;
      initialPassword = "changeme";
      hashedPasswordFile = mkIf secretsEnabled secretsCfg."passwords/root".path;
    };

    mainuser = {
      uid = 1000;
      shell = pkgs.zsh;
      description = config.globals.mainuser.nickname;
      initialPassword = "changeme";
      hashedPasswordFile = mkIf secretsEnabled secretsCfg."passwords/mainuser".path;
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
    extraSpecialArgs = { inherit inputs; };
    users.mainuser = {
      inherit (config) globals;

      imports = [
        ../../home
        ../../globals.nix
      ];
    };
  };
}
