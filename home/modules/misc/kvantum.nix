{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib)
    literalExpression
    mkIf
    mkOption
    mkPackageOption
    types
    ;

  cfg = config.qt.kvantum;

  toIni = lib.generators.toINI { };
in

{
  options.qt.kvantum = {
    theme = {
      name = mkOption {
        type = with types; nullOr str;
        default = null;
        example = "KvAdapta";
        description = ''
          The name of the Kvantum theme to use
        '';
      };

      package = mkPackageOption pkgs "Kvantum theme" {
        nullable = true;
        default = null;
        example = literalExpression "pkgs.catppuccin-kvantum";
      };
    };
  };

  config = mkIf config.qt.enable {
    home.packages = [ (mkIf (cfg.theme.package != null) cfg.theme.package) ];

    xdg.configFile = {
      "Kvantum/kvantum.kvconfig" = {
        text = toIni { General.theme = cfg.theme.name; };
      };
    };
  };
}
