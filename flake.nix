{
  description = "nix config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-treefmt.url = "github:nixos/nixpkgs/4533d9293756b63904b7238acb84ac8fe4c8c2c4";

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
      inputs.nixpkgs.follows = "nixpkgs-treefmt";
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
      url = "github:mikaeladev/pixel-cursors";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    rust = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
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
      self,
      nixpkgs,
      nixpkgs-treefmt,
      agenix,
      home-manager,
      treefmt,
      nvibrant,
      rust,
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
          rust.overlays.default
          self.overlays.default
        ];
      };

      mkNixosConfig = pkgs.lib.nixosSystem;
      mkHomeConfig = home-manager.lib.homeManagerConfiguration;

      treefmtPkgs = import nixpkgs-treefmt { inherit system; };
      treefmtEval = treefmt.lib.evalModule treefmtPkgs ./treefmt.nix;

      globals = {
        mainuser = {
          homeDirectory = "/home/mainuser";
          username = "mainuser";
          nickname = "mikaela";
        };
        mkXdgBaseDirectoryPaths = homeDir: {
          cacheHome = "${homeDir}/.local/var/cache";
          configHome = "${homeDir}/.local/etc";
          dataHome = "${homeDir}/.local/share";
          stateHome = "${homeDir}/.local/var/state";
        };
      };
    in

    {
      formatter.${system} = treefmtEval.config.build.wrapper;

      overlays.default = import ./pkgs { inherit inputs; };

      nixosConfigurations.desktop = mkNixosConfig {
        modules = [ ./nixos ];
        pkgs = pkgs;
        specialArgs = {
          inherit inputs;
          globals = globals // {
            standalone = false;
          };
        };
      };

      homeConfigurations.mainuser = mkHomeConfig {
        modules = [ ./home ];
        pkgs = pkgs;
        extraSpecialArgs = {
          inherit inputs;
          globals = globals // {
            standalone = true;
          };
        };
      };
    };
}
