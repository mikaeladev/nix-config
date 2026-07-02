# overrides & tweaks for generic linux

{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib) mkForce mkIf pathExists;
  inherit (config.lib.custom) wrapVulkan wrapPackage wrapStandaloneBin;
in

{
  config = mkIf config.targets.genericLinux.enable {
    home.packages = [
      # nixos uses `programs.steam.extraCompatPackages`
      pkgs.protonplus

      # stops nvidia-settings from cluttering $HOME
      (wrapPackage {
        flags."--config" = "${config.xdg.configHome}/nvidia/settings";
        package = wrapStandaloneBin "/usr/bin/nvidia-settings";
      })
    ];

    targets.genericLinux.gpu.nvidia = {
      enable = true;
      version = "595.71.05";
      sha256 = "sha256-NiA7iWC35JyKQva6H1hjzeNKBek9KyS3mK8G3YRva4I=";
    };

    programs = {
      zed-editor.package = wrapVulkan pkgs.zed-editor;
      prismlauncher.package = wrapVulkan pkgs.prismlauncher;
    };

    # install kvantum through system package manager
    qt.style.package = mkForce null;

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
  };
}
