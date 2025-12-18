{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib) mkEnableOption mkPackageOption mkIf;

  cfg = config.programs.prism-launcher;
in
{
  options.programs.prism-launcher = {
    enable = mkEnableOption "Enable Prism Launcher";

    package = mkPackageOption pkgs "prismlauncher" {
      nullable = true;
      default = pkgs.prismlauncher;
    };
  };

  config = mkIf cfg.enable {
    home.packages = [
      (mkIf (cfg.package != null) cfg.package)
    ];
  };
}
