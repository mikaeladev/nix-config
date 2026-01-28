{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib) mkEnableOption mkPackageOption mkIf;

  cfg = config.programs.krita;
in

{
  options.programs.krita = {
    enable = mkEnableOption "Krita";

    package = mkPackageOption pkgs "krita" {
      nullable = true;
      default = pkgs.krita;
    };
  };

  config = mkIf cfg.enable {
    home.packages = [ (mkIf (cfg.package != null) cfg.package) ];
  };
}
