{ globals, pkgs, ... }:

{
  imports = [
    ./configs
    ./modules
  ];

  home = {
    inherit (globals.mainuser) homeDirectory username;

    preferXdgDirectories = true;
    shell.enableZshIntegration = true;

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
