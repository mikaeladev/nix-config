{
  globals,
  inputs,
  pkgs,
  ...
}:

{
  imports = with inputs; [
    # flake modules
    nvibrant.homeModules.default
    plasma-manager.homeModules.plasma-manager
    spicetify.homeManagerModules.default
    zed-extensions.homeManagerModules.default
    zen-browser.homeModules.default
    # local modules
    ./configs
    ./modules
  ];

  home = {
    inherit (globals.mainuser) homeDirectory username;

    preferXdgDirectories = true;
    shell.enableZshIntegration = true;

    shellAliases = rec {
      # really useful for when plasmashell panels glitch out
      restart-plasma = "systemctl --user restart plasma-plasmashell";

      home-rebuild = "NIXPKGS_ALLOW_UNFREE=1 home-manager switch --impure";
      home-rollback = "${home-rebuild} --rollback";
    };

    stateVersion = "25.05";
  };

  news.display = "silent";

  nix = {
    assumeXdg = true;
    package = pkgs.nixVersions.latest;

    settings = {
      download-buffer-size = 524288000; # 500 MiB
    };
  };

  programs.home-manager.enable = true;
  targets.genericLinux.enable = globals.standalone;
}
