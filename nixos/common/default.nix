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
  
  rootPass = mkIf secretsEnabled secretsCfg."passwords/root".path;
  mainuserPass = mkIf secretsEnabled secretsCfg."passwords/mainuser".path;
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

  age.secrets = mkIf secretsEnabled {
    "networks".file = ../../secrets/networks.age;
    "passwords/root".file = ../../secrets/passwords/root.age;
    "passwords/mainuser".file = ../../secrets/passwords/mainuser.age;
  };

  users.users = {
    root = {
      isSystemUser = true;
      initialPassword = "changeme";
      hashedPasswordFile = rootPass;
      shell = pkgs.zsh;
    };

    mainuser = {
      isNormalUser = true;
      initialPassword = "changeme";
      hashedPasswordFile = mainuserPass;
      description = config.globals.mainuser.nickname;
      home = config.globals.mainuser.homeDirectory;
      shell = pkgs.zsh;
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
