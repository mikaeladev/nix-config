{
  globals,
  inputs,
  pkgs,
  ...
}:

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
    settings.download-buffer-size = 524288000; # 500 MiB
    assumeXdg = true;
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
