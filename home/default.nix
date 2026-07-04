{
  globals,
  inputs,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib) attrNames genAttrs' nameValuePair;
in

{
  imports = with inputs; [
    # flake modules
    nixvim.homeModules.nixvim
    plasma-manager.homeModules.plasma-manager
    spicetify.homeManagerModules.default
    zed-extensions.homeManagerModules.default
    zen-browser.homeModules.default
    # local modules
    ./configs
    ./modules
  ];

  nix = {
    package = pkgs.nixVersions.latest;
    assumeXdg = true;

    # keep nixpkgs channel in sync with this flake
    channels = { inherit (inputs) nixpkgs; };

    # keep flake registry in sync with this flake
    registry = genAttrs' (attrNames inputs) (
      s: nameValuePair s { flake = inputs.${s}; }
    );

    gc = {
      automatic = true;
      persistent = true;
      options = "--delete-older-than 7d";
      dates = "weekly";
    };

    settings = {
      download-buffer-size = 524288000; # 500 MiB;
      warn-dirty = false;
      max-jobs = 10;
      cores = 10;
    };
  };

  nixpkgs = {
    config = {
      allowUnfree = true;
      nvidia.acceptLicense = true;
    };

    overlays = with inputs; [
      agenix.overlays.default
      zed-extensions.overlays.default
      self.overlays.default
    ];
  };

  home = {
    inherit (globals.mainuser) homeDirectory username;

    preferXdgDirectories = true;
    shell.enableZshIntegration = true;

    shellAliases = {
      home-rebuild = "home-manager switch --impure";
      home-rollback = "home-manager switch --impure --rollback";
    };

    stateVersion = "25.05";
  };

  news.display = "silent";

  programs.home-manager.enable = true;
  targets.genericLinux.enable = globals.standalone;
}
