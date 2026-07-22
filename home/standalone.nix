# overrides & tweaks for generic linux

{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib) mkForce pathExists;
  inherit (config.lib.self) wrapVulkan wrapPackage wrapStandaloneBin;
in

{
  imports = [ ./. ];

  assertions = [
    {
      assertion = pathExists "/usr/bin/kvantummanager";
      message = "kvantum is not installed";
    }
    {
      assertion = pathExists "/usr/bin/nvidia-settings";
      message = "nvidia-settings is not installed";
    }
    {
      assertion = pathExists "/usr/bin/steam";
      message = "steam is not installed";
    }
  ];

  globals = {
    secrets = true;
    standalone = true;
    storage.enable = true;
  };

  home.packages = [
    # nixos uses `programs.steam.extraCompatPackages`
    pkgs.protonplus

    # stops nvidia-settings from cluttering $HOME
    (wrapPackage {
      flags."--config" = config.xdg.configHome + "/nvidia/settings";
      package = wrapStandaloneBin "/usr/bin/nvidia-settings";
    })
  ];

  programs = {
    gram.package = wrapVulkan pkgs.gram;
    prismlauncher.package = wrapVulkan pkgs.prismlauncher;
    zed-editor.package = wrapVulkan pkgs.zed-editor;
  };

  targets.genericLinux = {
    enable = true;
    gpu.nvidia = {
      enable = true;
      version = "595.71.05";
      sha256 = "sha256-NiA7iWC35JyKQva6H1hjzeNKBek9KyS3mK8G3YRva4I=";
    };
  };

  qt.style.package = mkForce null;
}
