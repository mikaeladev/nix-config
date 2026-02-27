# overrides & tweaks for generic linux

{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib) mkForce mkIf pathExists;
  inherit (config.lib.custom) wrapGraphics wrapPackage wrapStandaloneBin;
in

{
  config = mkIf config.targets.genericLinux.enable {
    home.packages = [
      # nixos uses `programs.steam.extraCompatPackages`
      pkgs.protonplus

      # spicetify module has no package override for spiced spotify
      (wrapGraphics config.programs.spicetify.spicedSpotify)

      # stops nvidia-settings from cluttering $HOME
      (wrapPackage {
        flags."--config" = "${config.xdg.configHome}/nvidia/settings";
        package = wrapStandaloneBin "/usr/bin/nvidia-settings";
      })
    ];

    home.sessionPath = [
      # set on nixos with `environment.localBinInPath`
      "${config.home.homeDirectory}/.local/bin"
    ];

    programs = {
      spicetify.enable = mkForce false;
      kitty.package = wrapGraphics pkgs.kitty;
      krita.package = wrapGraphics pkgs.krita;
      obs-studio.package = wrapGraphics pkgs.obs-studio;
      prismlauncher.package = wrapGraphics pkgs.prismlauncher;
      vesktop.package = wrapGraphics pkgs.vesktop;
      zapzap.package = wrapGraphics pkgs.zapzap;
      zed-editor.package = wrapGraphics pkgs.zed-editor;
      zen-browser.package = wrapGraphics pkgs.zen-browser;
    };

    services = {
      easyeffects.package = wrapGraphics pkgs.easyeffects;
    };

    targets.genericLinux.nixGL = {
      packages = inputs.nixGL.packages;
      defaultWrapper = "nvidia";
      installScripts = [ "nvidia" ];
      vulkan.enable = true;
    };

    # install kvantum through system package manager
    qt.style.package = mkForce null;

    xdg.configFile = {
      # standalone kvantum wont find themes in nix profiles
      "Kvantum/WhiteSur" = {
        source = "${config.qt.kvantum.theme.package}/share/Kvantum/WhiteSur";
      };
    };

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
