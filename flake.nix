{
  description = "nix config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-25.11";

    flatpaks.url = "github:gmodena/nix-flatpak";

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
      url = "github:nix-community/nixGL/pull/187/head";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    treefmt = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs-stable";
    };

    wrappers = {
      url = "github:Lassulus/wrappers";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # programs & overlays #

    nvibrant = {
      url = "github:mikaeladev/nix-nvibrant";
      inputs.nixpkgs.follows = "nixpkgs-stable";
    };

    pixel-cursors = {
      url = "github:mikaeladev/pixel-cursors";
      inputs.nixpkgs.follows = "nixpkgs-stable";
    };

    rust = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs-stable";
    };

    spicetify = {
      url = "github:Gerg-L/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs-stable";
    };

    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake/beta";
      inputs.nixpkgs.follows = "nixpkgs-stable";
      inputs.home-manager.follows = "home-manager";
    };
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      nixpkgs-stable,
      agenix,
      home-manager,
      treefmt,
      nvibrant,
      rust,
      ...
    }:

    let
      system = "x86_64-linux";

      pkgs-unstable = import nixpkgs {
        inherit system;

        config = {
          allowUnfree = true;
          nvidia.acceptLicense = true;
        };

        overlays = [
          agenix.overlays.default
          nvibrant.overlays.default
          rust.overlays.default
          self.overlays.default
        ];
      };

      pkgs-stable = import nixpkgs-stable {
        inherit system;

        config = {
          allowUnfree = true;
          nvidia.acceptLicense = true;
        };
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
        inherit globals inputs;
        pkgs = pkgs-unstable;
      };

      mkNixosConfig = nixpkgs.lib.nixosSystem;
      mkHomeConfig = home-manager.lib.homeManagerConfiguration;

      treefmtEval = treefmt.lib.evalModule pkgs-stable ./treefmt.nix;
    in

    {
      formatter.${system} = treefmtEval.config.build.wrapper;

      overlays.default = import ./pkgs { inherit inputs system; };

      nixosConfigurations.desktop = mkNixosConfig {
        lib = nixosLib;
        modules = [ ./nixos ];
        pkgs = pkgs-unstable;
        specialArgs = {
          inherit inputs pkgs-stable;
          globals = globals // {
            standalone = false;
          };
        };
      };

      homeConfigurations.mainuser = mkHomeConfig {
        modules = [ ./home ];
        pkgs = pkgs-unstable;
        extraSpecialArgs = {
          inherit inputs pkgs-stable;
          globals = globals // {
            standalone = true;
          };
        };
      };
    };
}
