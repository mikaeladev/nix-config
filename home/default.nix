{
  config,
  globals,
  inputs,
  lib,
  ...
}:

let
  inherit (lib) mkIf optionals;
in

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

    # this is set on nixos with `environment.localBinInPath`
    sessionPath = optionals globals.standalone [
      "${config.home.homeDirectory}/.local/bin"
    ];

    stateVersion = "25.05"; # do not change
  };

  news.display = "silent"; # SHUTUP

  programs.home-manager.enable = true;
  programs.plasma.enable = true;

  targets.genericLinux.nixGL = mkIf globals.standalone {
    packages = inputs.nixGL.packages;
    defaultWrapper = "nvidia";
    installScripts = [ "nvidia" ];
    vulkan.enable = true;
  };
}
