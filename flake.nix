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

    mac-style-plymouth = {
      url = "github:SergioRibera/s4rchiso-plymouth-theme";
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

    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake/beta";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
  };

  outputs =
    inputs@{
      nixpkgs,
      home-manager,
      mac-style-plymouth,
      nvibrant,
      ...
    }:

    let
      system = "x86_64-linux";

      pkgs = import nixpkgs {
        inherit system;
        config = {
          allowUnfree = true;
        };
        overlays = [
          mac-style-plymouth.overlays.default
          nvibrant.overlays.default
          (import ./pkgs { inherit inputs system; })
        ];
      };

      globals = rec {
        lib = import ./lib { inherit inputs pkgs system; };

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

      mkSystem = nixpkgs.lib.nixosSystem;
      mkHome = home-manager.lib.homeManagerConfiguration;
    in

    {
      nixosConfigurations.desktop = mkSystem {
        inherit pkgs;
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
