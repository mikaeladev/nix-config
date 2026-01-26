{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib)
    literalExpression
    mkEnableOption
    mkOption
    mkMerge
    mkIf
    types
    ;

  cfg = config.programs.kvantum;

  toKvconfig = lib.generators.toINI { };
in

{
  options.programs.kvantum = {
    enable = mkEnableOption "Enable Kvantum";

    package = mkOption {
      type = types.nullOr types.package;
      default = pkgs.kdePackages.qtstyleplugin-kvantum;
      example = literalExpression "pkgs.kdePackages.qtstyleplugin-kvantum";
      description = ''
        Package providing Kvantum. This package will be installed to your
        profile. If `null` then Kvantum is assumed to already be available in
        your profile.
      '';
    };

    theme = {
      name = mkOption {
        type = types.str;
        description = ''
          The active Kvantum theme name.
        '';
      };

      package = mkOption {
        type = types.nullOr types.package;
        default = null;
        example = literalExpression "pkgs.catppuccin-kvantum";
        description = ''
          Package providing the Kvantum theme. This package will be installed
          to your profile. If `null` then the theme is assumed to already be
          available in your profile.
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    home.packages = mkMerge [
      [ (mkIf (cfg.package != null) cfg.package) ]
      [ (mkIf (cfg.theme.package != null) cfg.theme.package) ]
    ];

    xdg.configFile."./Kvantum/kvantum.kvconfig".text = toKvconfig {
      General = {
        theme = cfg.theme.name;
      };
    };
  };
}
