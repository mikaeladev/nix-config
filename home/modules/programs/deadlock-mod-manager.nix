{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib) mkEnableOption mkPackageOption mkIf;

  cfg = config.programs.deadlock-mod-manager;
in

{
  options.programs.deadlock-mod-manager = {
    enable = mkEnableOption "Enable Deadlock Mod Manager";

    package = mkPackageOption pkgs "deadlock-mod-manager" {
      nullable = true;
      default = pkgs.deadlock-mod-manager;
    };
  };

  config = mkIf cfg.enable {
    home.packages = [
      (mkIf (cfg.package != null) cfg.package)
    ];
  };
}
