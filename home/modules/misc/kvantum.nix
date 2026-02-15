{ config, lib, ... }:

let
  inherit (lib)
    literalExpression
    mkIf
    mkOption
    types
    ;

  cfg = config.qt.kvantum;

  toIni = lib.generators.toINI { };
in

{
  options.qt.kvantum = {
    theme = mkOption {
      type = with types; nullOr str;
      default = null;
      example = "KvAdapta";
      description = ''
        The Kvantum theme to use
      '';
    };

    extraPackages = mkOption {
      type = with types; listOf package;
      default = [ ];
      example = literalExpression ''
        [
          pkgs.catppuccin-kvantum
          pkgs.gruvbox-kvantum
          pkgs.rose-pine-kvantum
        ];
      '';
      description = ''
        Additional theme packages to install
      '';
    };
  };

  config = mkIf config.qt.enable {
    home.packages = cfg.extraPackages;

    xdg.configFile = {
      "Kvantum/kvantum.kvconfig" = {
        text = toIni { General.theme = cfg.theme; };
      };
    };
  };
}
