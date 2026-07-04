{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib) mkEnableOption mkIf mkPackageOption;
  inherit (pkgs) buildEnv coreutils;

  cfg = config.services.openlinkhub;

  workingDir = "\${XDG_RUNTIME_DIR:-/run/user/$UID}/OpenLinkHub";

  runtimeEnv = buildEnv {
    name = "openlinkhub";
    paths = [ "${cfg.package}/opt/OpenLinkHub" ];
    postBuild = ''
      mv database _database

      ln -st ${config.xdg.configHome}/OpenLinkHub \
        database config.json dashboard.json display.json
    '';
  };
in

{
  options.services.openlinkhub = {
    enable = mkEnableOption "OpenLinkHub";

    package = mkPackageOption pkgs "openlinkhub" { };
  };

  config = mkIf cfg.enable {
    systemd.user = {
      services.OpenLinkHub = {
        Unit = {
          After = "default.target";
          Description = cfg.package.meta.description;
          StartLimitIntervalSec = 60;
          StartLimitBurst = 5;
        };
        Service = {
          WorkingDirectory = workingDir;
          ExecStart = "${workingDir}/OpenLinkHub";
          ExecReload = "${coreutils}/bin/kill -s HUP $MAINPID";
          Restart = "always";
          RestartSec = 5;
        };
        Install = {
          WantedBy = "default.target";
        };
      };

      tmpfiles.rules = [
        # %t == $XDG_RUNTIME_DIR
        "L+ ${runtimeEnv} - - - - %t/OpenLinkHub"
      ];
    };
  };
}
