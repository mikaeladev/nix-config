{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib)
    attrsToList
    concatLines
    concatStringsSep
    fromJSON
    getExe
    hasSuffix
    hm
    isString
    literalExpression
    maintainers
    makeBinPath
    mkEnableOption
    mkForce
    mkIf
    mkOption
    mkPackageOption
    optionals
    path
    platforms
    types
    ;
  inherit (pkgs)
    buildEnv
    coreutils
    diffutils
    formats
    getent
    gnugrep
    jq
    su
    substitute
    systemd
    writeShellScript
    writeTextDir
    ;

  concatMapLines = f: list: concatLines (map f list);

  withSuffix =
    suffix: value: if (hasSuffix suffix value) then value else (value + suffix);

  jsonFormat = formats.json { };

  cfg = config.services.openlinkhub;
  configDir = "${config.xdg.configHome}/OpenLinkHub";
in

{
  meta.maintainers = with maintainers; [ mikaeladev ];

  options.services.openlinkhub = {
    enable = mkEnableOption "OpenLinkHub";

    package = mkPackageOption pkgs "openlinkhub" { };

    config = mkOption {
      type = types.nullOr jsonFormat.type;
      default = null;
      example = {
        frontend = true;
        listenAddress = "127.0.0.1";
        listenPort = 27003;
        logLevel = "info";
      };
      description = ''
        Configuration to be merged into {file}`config.json`.

        This is equivalent to setting {option}`extraConfigs."config.json"`.
      '';
    };

    dashboard = mkOption {
      type = types.nullOr jsonFormat.type;
      default = null;
      example = {
        celsius = true;
        pageTitle = "OpenLinkHub WebUI";
        languageCode = "en_US";
        theme = "default";
      };
      description = ''
        Dashboard settings to be merged into {file}`dashboard.json`.

        This is equivalent to setting {option}`extraConfigs."dashboard.json"`.
      '';
    };

    memory = {
      enable = mkEnableOption "memory configuration";

      sku = mkOption {
        type = with types; nullOr str;
        default = null;
        example = "CMT64GX5M2B5600Z40";
        description = ''
          The SKU of the device.

          You can find this by running `sudo dmidecode -t memory` and grepping
          by 'Part Number'.

          See the OpenLinkHub [docs] for more information.

          [docs]: https://github.com/jurkovic-nikola/OpenLinkHub/blob/main/docs/memory-configuration.md
        '';
      };

      smb = mkOption {
        type = with types; nullOr (strMatching "i2c-[[:digit:]]");
        default = null;
        example = "i2c-0";
        description = ''
          The SMBus controller for the device.

          You can find this by running `i2cdetect -l` and grepping by 'SMBus',
          with it typically being the first device from the list.

          See the OpenLinkHub [docs] for more information.

          [docs]: https://github.com/jurkovic-nikola/OpenLinkHub/blob/main/docs/memory-configuration.md
        '';
      };

      type = mkOption {
        type = with types; nullOr (ints.between 4 5);
        default = null;
        example = 5;
        description = ''
          Which generation the device belongs to.

          You can find this by running `sudo dmidecode -t memory` and grepping
          by 'Type: DDR[4-5]'.

          See the OpenLinkHub [docs] for a full list of supported devices and
          their generations.

          [docs]: https://github.com/jurkovic-nikola/OpenLinkHub/blob/main/docs/supported-devices.md
        '';
      };
    };

    extraConfigs = mkOption {
      type = with types; attrsOf (either jsonFormat.type lines);
      default = { };
      example = literalExpression ''
        {
          # merges with existing `i2c0.json`
          "database/profiles/i2c0.json" = {
            Active = true;
            Path = "/run/user/1000/OpenLinkHub/database/profiles/i2c0.json";
            Product = "Memory";
            Serial = "i2c0";
            # ...
          };
          # overwrites existing `display.json`
          "display.json" = '''
            [
              {
                "Index": 1,
                "Name": "card1-DP-1",
                "Width": 2560,
                "Height": 1440,
                # ...
              }
            ]
          ''';
        }
      '';
      description = ''
        Additional files to be written to {file}`$XDG_CONFIG_HOME/OpenLinkHub`.

        Content generated from an attrset will be merged, while content passed
        as lines will be written as is, overwriting any previous data.
      '';
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
        (assertMemoryOptionNotNull "sku")
        (assertMemoryOptionNotNull "smb")
        (assertMemoryOptionNotNull "type")
      ];

    services.openlinkhub = {
      config = mkIf cfg.memory.enable {
        memory = mkForce true;
        memorySku = mkForce cfg.memory.sku;
        memorySmBus = mkForce cfg.memory.smb;
        memoryType = mkForce cfg.memory.type;
      };

      extraConfigs = {
        "config.json" = mkIf (cfg.config != null) (mkForce cfg.config);
        "dashboard.json" = mkIf (cfg.dashboard != null) (mkForce cfg.dashboard);
      };
    };

    systemd.user = {
      services.OpenLinkHub = {
        Unit = {
          After = [ "default.target" ];
          Description = cfg.package.meta.description;
          StartLimitIntervalSec = 60;
          StartLimitBurst = 5;
        };
        Service = {
          ExecStart = getExe cfg.package;
          ExecReload = "${coreutils}/bin/kill -s HUP $MAINPID";
          WorkingDirectory = "%t/OpenLinkHub";
          Restart = "always";
          RestartSec = 5;
        };
        Install = {
          WantedBy = [ "default.target" ];
        };
      };

      tmpfiles.rules =
        let
          runtimeEnv = buildEnv {
            name = "openlinkhub";
            paths = [ "${cfg.package}/opt/OpenLinkHub" ];
            postBuild = ''
              rm $out/database
              ln -st $out \
                ${configDir}/{database,config.json,dashboard.json,display.json}
            '';
          };
        in
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
                  ''OWNER="${groupName}"''
                  ''GROUP="${groupName}"''
                ];
              })
            ]
            ++ (optionals cfg.memory.enable [
              (writeTextDir "98-corsair-memory.rules" ''
                KERNEL=="${cfg.memory.smb}", MODE="0600", GROUP="${groupName}"
              '')
            ]);
          };

          setupScript = writeShellScript "openlinkhub-setup" ''
            set -euo pipefail

            PATH="${
              makeBinPath [
                coreutils
                getent
                gnugrep
                su
                systemd
              ]
            }''${PATH:+:}$PATH"

            if ! getent group ${groupName} >/dev/null; then
              for gid in $(seq 999 -1 900); do
                if ! getent group $gid >/dev/null; then
                  groupadd -g $gid ${groupName}
                  echo "created group '${groupName}' with gid $gid"
                  break
                fi
              done
            fi

            if ! id -nG $UID | grep -qw ${groupName}; then
              usermod -aG ${groupName} $UID
              echo "added user $UID to '${groupName}'"
            fi

            ln -fst ${udevDir} ${udevRules}/*
            ln -fst "''${NIX_STATE_DIR:-/nix/var/nix}/gcroots" ${udevRules}/*
            echo "updated udev rules"

            udevadm control --reload-rules
            udevadm trigger
          '';

          missingConditions = [
            "! ${getExe getent} group ${groupName} >/dev/null"
            "[ ! -L ${udevDir}/99-openlinkhub.rules ]"
          ]
          ++ (optionals cfg.memory.enable [
            "[ ! -L ${udevDir}/98-corsair-memory.rules ]"
          ]);

          outdatedConditions = [
            "! ${coreutils}/bin/id -nG $UID | ${getExe gnugrep} -qw ${groupName}"
            "! ${diffutils}/bin/cmp -s ${udevDir}/99-openlinkhub.rules"
          ]
          ++ (optionals cfg.memory.enable [
            "! ${diffutils}/bin/cmp -s ${udevDir}/98-corsair-memory.rules"
          ]);
        in
        hm.dag.entryAnywhere ''
          if ${concatStringsSep " || " missingConditions}; then
            warnEcho "To finish setting up OpenLinkHub, run"
            warnEcho "  sudo ${setupScript}"
          elif ${concatStringsSep " || " outdatedConditions}; then
            warnEcho "OpenLinkHub requires an update, run"
            warnEcho "  sudo ${setupScript}"
          fi
        '';

      configureOpenLinkHub = hm.dag.entryAfter [ "writeBoundary" ] ''
        runEval() {
          if [[ -v DRY_RUN ]]; then
            echo "$1"
          else
            eval "$1"
          fi
        }

        writeConfig() {
          runEval "cat '$1' > '$2'"
        }

        mergeConfig() {
          runEval "${getExe jq} -s 'reduce .[] as \$obj ({}; . * \$obj)' '$2' '$1' > '$2'"
        }

        run mkdir -p "${configDir}"

        run cp -ru ${cfg.package}/opt/OpenLinkHub/database \
          '${configDir}/database'

        ${concatMapLines (
          { name, value }:
          let
            nameWithSuffix = withSuffix ".json" name;

            configPath = path.subpath.join [
              configDir
              nameWithSuffix
            ];

            configFile = jsonFormat.generate (baseNameOf configPath) (
              if isString value then fromJSON value else value
            );
          in
          if isString value then
            ''
              writeConfig '${configFile}' '${configPath}'
            ''
          else
            ''
              if [ -e '${configPath}' ]; then
                mergeConfig '${configFile}' '${configPath}'
              else
                writeConfig '${configFile}' '${configPath}'
              fi
            ''
        ) (attrsToList cfg.extraConfigs)}

        unset -f runEval writeConfig mergeConfig
      '';
    };
  };
}
