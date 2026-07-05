{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib)
    concatStringsSep
    getExe
    hm
    maintainers
    mkEnableOption
    mkIf
    mkOption
    mkPackageOption
    optionals
    platforms
    types
    ;
  inherit (pkgs)
    buildEnv
    coreutils
    substitute
    writeShellScript
    writeTextDir
    ;

  cfg = config.services.openlinkhub;
  cfgDir = "${config.xdg.configHome}/OpenLinkHub";
in

{
  meta.maintainers = with maintainers; [ mikaeladev ];

  options.services.openlinkhub = {
    enable = mkEnableOption "OpenLinkHub";

    package = mkPackageOption pkgs "openlinkhub" { };

    memory = {
      enable = mkEnableOption "memory configuration";

      type = mkOption {
        type =
          with types;
          nullOr (enum [
            4
            5
          ]);
        default = null;
        example = 5;
        description = ''
          Which generation the device belongs to.

          See the OpenLinkHub [docs] for a full list of supported devices and
          their respective generations.

          [docs]: https://github.com/jurkovic-nikola/OpenLinkHub/blob/main/docs/supported-devices.md
        '';
      };

      sku = mkOption {
        type = with types; nullOr str;
        default = null;
        example = "CMT64GX5M2B5600Z40";
        description = ''
          The SKU of the device.

          You can typically find this by running `dmidecode -t memory` and
          grepping by 'Part Number'.

          See the OpenLinkHub [docs] for more information.

          [docs]: https://github.com/jurkovic-nikola/OpenLinkHub/blob/main/docs/memory-configuration.md
        '';
      };

      smb = mkOption {
        type = with types; nullOr (strMatching "i2c-[[:digit:]]");
        default = null;
        example = "i2c-15";
        description = ''
          The SMBus controller for the device.

          This value will vary from system to system. Usually, it's the first
          `smbus` device in the output from `i2cdetect -l`.

          See the OpenLinkHub [docs] for more information.

          [docs]: https://github.com/jurkovic-nikola/OpenLinkHub/blob/main/docs/memory-configuration.md
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    assertions =
      let
        inherit (hm.assertions) assertPlatform;

        assertMemoryOptionNotNull = opt: {
          assertion = cfg.memory.${opt} != null;
          message = ''
            The option `services.openlinkhub.memory.${opt}` must not be null when
            `services.openlinkhub.memory.enable` is set to true.
          '';
        };
      in
      [ (assertPlatform "services.openlinkhub" pkgs platforms.linux) ]
      ++ optionals (cfg.memory.enable) [
        (assertMemoryOptionNotNull "type")
        (assertMemoryOptionNotNull "sku")
        (assertMemoryOptionNotNull "smb")
      ];

    systemd.user = {
      services.OpenLinkHub = {
        Unit = {
          After = "default.target";
          Description = cfg.package.meta.description;
          StartLimitIntervalSec = 60;
          StartLimitBurst = 5;
        };
        Service = {
          ExecStart = getExe cfg.package;
          ExecReload = "${coreutils}/bin/kill -s HUP $MAINPID";
          WorkingDirectory = "\${XDG_RUNTIME_DIR:-/run/user/$UID}/OpenLinkHub";
          Restart = "always";
          RestartSec = 5;
        };
        Install = {
          WantedBy = "default.target";
        };
      };

      tmpfiles.rules =
        let
          runtimeEnv = buildEnv {
            name = "openlinkhub";
            paths = [ "${cfg.package}/opt/OpenLinkHub" ];
            postBuild = ''
              rm database
              ln -st ${cfgDir} database config.json dashboard.json display.json
            '';
          };
        in
        # %t == $XDG_RUNTIME_DIR
        [ "C+ ${runtimeEnv} - - - - %t/OpenLinkHub" ];
    };

    home.activation = {
      checkOpenLinkHubSetup =
        let
          groupName = "openlinkhub";
          udevDir = "/etc/udev/rules.d";

          udevRules = buildEnv {
            name = "openlinkhub-udev-rules";
            paths = [
              (substitute {
                src = "${cfg.package}${udevDir}/99-openlinkhub.rules";
                dir = "/";
                substitutions = [
                  "--replace-fail"
                  "'OWNER=\"${groupName}\"'"
                  "'GROUP=\"${groupName}\"'"
                ];
              })
            ]
            ++ (optionals cfg.memory.enable [
              (writeTextDir "98-corsair-memory.rules" ''
                KERNEL=="${cfg.memory.smb}", MODE="0600", GROUP="${groupName}"
              '')
            ]);
          };

          setupPackage = writeShellScript "openlinkhub-setup" ''
            set -euo pipefail

            if ! getent group ${groupName} >/dev/null; then
              for gid in $(seq 999 -1 900); do
                if ! getent group "$gid" >/dev/null; then
                  groupadd -g "$gid" ${groupName}
                  echo "created group '${groupName}' with gid $gid"
                  break
                fi
              done
            fi

            if ! id -nG $UID | grep -qw ${groupName}; then
              usermod -aG ${groupName} $UID
              echo "added user $UID to ${groupName}"
            fi

            ln -fst ${udevDir} ${udevRules}/*
            echo "updated udev rules"

            udevadm control --reload-rules
            udevadm trigger
          '';

          missingConditions = [
            "! getent group ${groupName} >/dev/null"
            "[ ! -L ${udevDir}/99-openlinkhub.rules ]"
          ]
          ++ (optionals cfg.memory.enable [
            "[ ! -L ${udevDir}/98-corsair-memory.rules ]"
          ]);

          outdatedConditions = [
            "! id -nG $UID | grep -qw ${groupName}"
            "! cmp -s ${udevDir}/99-openlinkhub.rules"
          ]
          ++ (optionals cfg.memory.enable [
            "! cmp -s ${udevDir}/98-corsair-memory.rules"
          ]);
        in
        hm.dag.entryAnywhere ''
          if ${concatStringsSep " || " missingConditions}; then
            warnEcho "To finish setting up OpenLinkHub, run"
            warnEcho "  sudo ${setupPackage}"
          elif ${concatStringsSep " || " outdatedConditions}; then
            warnEcho "OpenLinkHub requires an update, run"
            warnEcho "  sudo ${setupPackage}"
          fi
        '';
    };
  };
}
