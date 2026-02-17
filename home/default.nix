{ globals, inputs, ... }:

{
  imports = [
    inputs.plasma-manager.homeModules.plasma-manager
    ./configs
    ./modules
  ];

  home = {
    username = globals.mainuser.username;
    homeDirectory = "/home/${globals.mainuser.username}";

    preferXdgDirectories = true;
    shell.enableZshIntegration = true;

    stateVersion = "25.05"; # do not change
  };

  news.display = "silent"; # SHUTUP

  programs.home-manager.enable = true;
  programs.plasma.enable = true;

  targets.genericLinux.enable = globals.standalone;
}
