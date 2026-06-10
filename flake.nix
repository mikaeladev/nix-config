{
  description = "nix config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.darwin.follows = "";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    plasma-manager = {
      url = "github:nix-community/plasma-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };

    # utils & wrappers #

    nixGL = {
      url = "github:tsssni/nixGL";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    treefmt = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    wrappers = {
      url = "github:Lassulus/wrappers";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # programs & overlays #

    nvibrant = {
      url = "github:mikaeladev/nix-nvibrant";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    pixel-cursors = {
      url = "github:mikaeladev/pixel-cursors/cebd9ab8304282840bd2fde6ebff8166f4627230";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    spicetify = {
      url = "github:Gerg-L/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    zed-extensions = {
      url = "github:DuskSystems/nix-zed-extensions";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake/beta";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      agenix,
      home-manager,
      treefmt,
      zed-extensions,
      ...
    }:

    let
      system = "x86_64-linux";

      pkgs = import nixpkgs {
        inherit system;

        config = {
          allowUnfree = true;
          nvidia.acceptLicense = true;
        };

        overlays = [
          agenix.overlays.default
          zed-extensions.overlays.default
          self.overlays.default
        ];
      };

      treefmtEval = treefmt.lib.evalModule pkgs ./treefmt.nix;

      mkNixosConfig = pkgs.lib.nixosSystem;
      mkHomeConfig = home-manager.lib.homeManagerConfiguration;

      mkGlobals =
        attrs:
        rec {
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
        inherit pkgs;
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
