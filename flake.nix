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
    {
      nixpkgs,
      home-manager,
      treefmt,
      ...
    }@inputs:

    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};

      treefmtEval = treefmt.lib.evalModule pkgs ./treefmt.nix;

      mkNixosConfig = nixpkgs.lib.nixosSystem;
      mkHomeConfig = home-manager.lib.homeManagerConfiguration;

      specialArgs = { inherit inputs; };
      extraSpecialArgs = specialArgs;
    in

    {
      formatter.${system} = treefmtEval.config.build.wrapper;

      overlays.default = import ./overlay.nix { inherit inputs; };

      homeConfigurations = {
        mainuser = mkHomeConfig {
          inherit extraSpecialArgs pkgs;
          modules = [
            ./home/standalone.nix
            ./globals.nix
          ];
        };
      };

      nixosConfigurations = {
        nixos = mkNixosConfig {
          inherit specialArgs;
          modules = [
            # ./nixos/machines/nixos
            ./globals.nix
          ];
        };
      };
    };
}
