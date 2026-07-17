{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    # dependencies #

    systems.url = "github:nix-systems/default";

    flake-utils = {
      url = "github:numtide/flake-utils";
      inputs.systems.follows = "systems";
    };

    treefmt = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # core modules #

    home-manager = {
      url = "github:nix-community/home-manager/pull/9631/head";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
      inputs.systems.follows = "systems";
      inputs.darwin.follows = "";
    };

    # home modules #

    plasma-manager = {
      url = "github:nix-community/plasma-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };

    spicetify = {
      url = "github:gerg-l/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.systems.follows = "systems";
    };

    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake/beta";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };

    # packages #

    pixel-cursors = {
      url = "github:mikaeladev/pixel-cursors/cebd9ab";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
      inputs.treefmt-nix.follows = "treefmt";
    };

    zed-extensions = {
      url = "github:dusksystems/nix-zed-extensions";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.rust-overlay.inputs.nixpkgs.follows = "nixpkgs";
    };

    # utils #

    wrappers = {
      url = "github:lassulus/wrappers";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{
      nixpkgs,
      home-manager,
      treefmt,
      ...
    }:

    let
      system = "x86_64-linux";

      pkgs = nixpkgs.legacyPackages.${system};

      treefmtEval = treefmt.lib.evalModule pkgs ./treefmt.nix;

      mkNixosConfig = nixpkgs.lib.nixosSystem;
      mkHomeConfig = home-manager.lib.homeManagerConfiguration;

      mkGlobals =
        attrs:
        rec {
          secrets = true;
          standalone = false;

          mainuser = {
            nickname = "mikaela";
            username = "mainuser";
            homeDirectory = "/home/mainuser";
          };

          storageDevice = {
            uuid = "191e3f9d-df7c-4b99-8d03-1c2c65a1dc7b";
            mountPoint = "${mainuser.homeDirectory}/storage";
          };

          xdgBaseDirectoryParts = {
            configHome = ".local/etc";
            dataHome = ".local/share";
            cacheHome = ".local/var/cache";
            stateHome = ".local/var/state";
          };
        }
        // attrs;
    in

    {
      formatter.${system} = treefmtEval.config.build.wrapper;

      overlays.default = import ./overlay.nix inputs;

      nixosConfigurations.desktop = mkNixosConfig {
        modules = [ ./nixos ];
        specialArgs = {
          inherit inputs;
          globals = mkGlobals {
            efiDevice = "B18D-67CD";
            nixosDevice = "b9b31136-98f5-4ec9-b5e8-2b9b12bc4983";
          };
        };
      };

      homeConfigurations.mainuser = mkHomeConfig {
        inherit pkgs;
        modules = [ ./home ];
        extraSpecialArgs = {
          inherit inputs;
          globals = mkGlobals { standalone = true; };
        };
      };
    };
}
