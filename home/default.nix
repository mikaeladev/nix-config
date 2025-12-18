{
  config,
  globals,
  inputs,
  lib,
  ...
}:

let
  inherit (lib) mkIf;
in

{
  imports = [
    inputs.plasma-manager.homeModules.plasma-manager
    ./configs
    ./modules
  ];

  # home manager config
  home = {
    username = globals.mainuser.username;
    homeDirectory = "/home/${globals.mainuser.username}";
    preferXdgDirectories = true;
    shell.enableZshIntegration = true;

    sessionPath = mkIf globals.standalone [
      "${config.home.homeDirectory}/.local/bin"
    ];

    stateVersion = "25.05"; # do not change
  };

  news.display = "silent"; # SHUTUP

  # enable nixGL wrappers
  targets.genericLinux.nixGL = {
    packages = inputs.nixGL.packages;
    defaultWrapper = "nvidia";
    installScripts = [ "nvidia" ];
    vulkan.enable = true;
  };

  # allow proprietary software
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.nvidia.acceptLicense = true;

  programs.home-manager.enable = true;
  programs.plasma.enable = true;
}
