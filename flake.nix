{
  description = "nix config flake";

  inputs = {
    nixpkgs = {
      url = "github:nixos/nixpkgs/nixos-unstable";
    };

    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.darwin.follows = "";
    };

    flatpaks = {
      url = "github:gmodena/nix-flatpak";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixGL = {
      url = "github:nix-community/nixGL/pull/187/head";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nvibrant = {
      url = "github:mikaeladev/nix-nvibrant";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    pixel-cursors = {
      url = "github:mikaeladev/pixel-cursors";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    plasma-manager = {
      url = "github:nix-community/plasma-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };

    spicetify = {
      url = "github:Gerg-L/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    
    wrappers = {
      url = "github:Lassulus/wrappers";
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
      nvibrant,
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
          nvibrant.overlays.default
          self.overlays.default
        ];
      };

      globals = rec {
        mainuser = {
          username = "mainuser";
          nickname = "mikaela";

          xdg = {
            cacheHome = "/home/${mainuser.username}/.local/var/cache";
            configHome = "/home/${mainuser.username}/.local/etc";
            dataHome = "/home/${mainuser.username}/.local/share";
            stateHome = "/home/${mainuser.username}/.local/var/state";
          };
        };
      };
      
      nixosLib = import ./nixos/modules/lib/extend-lib.nix {
        inherit globals inputs pkgs;
      };

      mkNixos = nixpkgs.lib.nixosSystem;
      mkHome = home-manager.lib.homeManagerConfiguration;
    in

    {
      overlays.default = import ./pkgs { inherit inputs system; };

      nixosConfigurations.desktop = mkNixos {
        inherit pkgs;
        lib = nixosLib;
        modules = [ ./nixos ];
        specialArgs = {
          inherit inputs;
          globals = globals // {
            standalone = false;
          };
        };
      };

      homeConfigurations.mainuser = mkHome {
        inherit pkgs;
        modules = [ ./home ];
        extraSpecialArgs = {
          inherit inputs;
          globals = globals // {
            standalone = true;
          };
        };
      };
    };
}
