{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib)
    concatMapAttrs
    literalExpression
    mkEnableOption
    mkIf
    mkMerge
    mkOption
    optionals
    path
    types
    ;

  json = pkgs.formats.json { };

  mkExtraConfigOption =
    { example, description }:
    mkOption {
      inherit example description;
      type = types.attrsOf json.type;
      default = { };
    };

  cfg = config.services.pipewire;
in

{
  meta.maintainers = with lib.hm.maintainers; [ mikaeladev ];

  options.services.pipewire = {
    enable = mkEnableOption "PipeWire server configs";

    extraConfig = mkExtraConfigOption {
      example = {
        "10-clock-rate" = {
          "context.properties" = {
            "default.clock.rate" = 44100;
          };
        };
        "11-no-upmixing" = {
          "stream.properties" = {
            "channelmix.upmix" = false;
          };
        };
      };
      description = ''
        Additional configuration for the PipeWire server.

        Every item in this attrset becomes a separate drop-in file in `$XDG_CONFIG_HOME/pipewire/pipewire.conf.d`.

        See `man pipewire.conf` for details, and [the PipeWire wiki][wiki] for examples.

        [wiki]: https://gitlab.freedesktop.org/pipewire/pipewire/-/wikis/Config-PipeWire
      '';
    };

    client = {
      enable = mkEnableOption "PipeWire client library configs";

      extraConfig = mkExtraConfigOption {
        example = {
          "10-no-resample" = {
            "stream.properties" = {
              "resample.disable" = true;
            };
          };
        };
        description = ''
          Additional configuration for the PipeWire client library, used by most applications.

          Every item in this attrset becomes a separate drop-in file in `$XDG_CONFIG_HOME/pipewire/client.conf.d`.

          See the [PipeWire wiki][wiki] for examples.

          [wiki]: https://gitlab.freedesktop.org/pipewire/pipewire/-/wikis/Config-client
        '';
      };
    };

    jack = {
      enable = mkEnableOption "PipeWire JACK server configs";

      extraConfig = mkExtraConfigOption {
        example = {
          "20-hide-midi" = {
            "jack.properties" = {
              "jack.show-midi" = false;
            };
          };
        };
        description = ''
          Additional configuration for the PipeWire JACK server and client library.

          Every item in this attrset becomes a separate drop-in file in `$XDG_CONFIG_HOME/pipewire/jack.conf.d`.

          See the [PipeWire wiki][wiki] for examples.

          [wiki]: https://gitlab.freedesktop.org/pipewire/pipewire/-/wikis/Config-JACK
        '';
      };
    };

    pulse = {
      enable = mkEnableOption "PipeWire PulseAudio server configs";

      extraConfig = mkExtraConfigOption {
        example = {
          "15-force-s16-info" = {
            "pulse.rules" = [
              {
                matches = [ { "application.process.binary" = "my-broken-app"; } ];
                actions = {
                  quirks = [ "force-s16-info" ];
                };
              }
            ];
          };
        };
        description = ''
          Additional configuration for the PipeWire PulseAudio server.

          Every item in this attrset becomes a separate drop-in file in `$XDG_CONFIG_HOME/pipewire/pipewire-pulse.conf.d`.

          See `man pipewire-pulse.conf` for details, and [the PipeWire wiki][wiki] for examples.

          [wiki]: https://gitlab.freedesktop.org/pipewire/pipewire/-/wikis/Config-PulseAudio
        '';
      };
    };

    wireplumber = {
      enable = mkEnableOption "WirePlumber daemon configs";

      extraConfig = mkExtraConfigOption {
        example = literalExpression ''
          {
            "log-level-debug" = {
              "context.properties" = {
                # Output Debug log messages as opposed to only the default level (Notice)
                "log.level" = "D";
              };
            };
            "wh-1000xm3-ldac-hq" = {
              "monitor.bluez.rules" = [
                {
                  matches = [
                    {
                      # Match any bluetooth device with ids equal to that of a WH-1000XM3
                      "device.name" = "~bluez_card.*";
                      "device.product.id" = "0x0cd3";
                      "device.vendor.id" = "usb:054c";
                    }
                  ];
                  actions = {
                    update-props = {
                      # Set quality to high quality instead of the default of auto
                      "bluez5.a2dp.ldac.quality" = "hq";
                    };
                  };
                }
              ];
            };
          }
        '';
        description = ''
          Additional configuration for the WirePlumber daemon.

          Every item in this attrset becomes a separate drop-in file in `$XDG_CONFIG_HOME/wireplumber/wireplumber.conf.d`.

          See the matching [NixOS option][nixos-option] for details.

          [nixos-option]: https://search.nixos.org/options?channel=25.11&type=options&show=services.pipewire.wireplumber.extraConfig
        '';
      };

      extraScripts = mkOption {
        type = with types; attrsOf lines;
        default = { };
        example = {
          "test/hello-world.lua" = ''
            print("Hello, world!")
          '';
        };
        description = ''
          Additional scripts for WirePlumber to be used by configuration files.

          Every item in this attrset becomes a separate drop-in file in `$XDG_DATA_HOME/wireplumber/scripts`.

          See the matching [NixOS option][nixos-option] for details.

          [nixos-option]: https://search.nixos.org/options?channel=25.11&type=options&show=services.pipewire.wireplumber.extraScripts
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    xdg.configFile =
      let
        mapConfigToFiles =
          location: config:
          concatMapAttrs (name: value: {
            "${location}.conf.d/${name}.conf".source = json.generate "${name}" value;
          }) config;
      in
      mkMerge (
        [ (mapConfigToFiles "pipewire/pipewire" cfg.extraConfig) ]
        ++ (optionals (cfg.client.enable) [
          (mapConfigToFiles "pipewire/client" cfg.client.extraConfig)
        ])
        ++ (optionals (cfg.jack.enable) [
          (mapConfigToFiles "pipewire/jack" cfg.jack.extraConfig)
        ])
        ++ (optionals (cfg.pulse.enable) [
          (mapConfigToFiles "pipewire/pipewire-pulse" cfg.pulse.extraConfig)
        ])
        ++ (optionals (cfg.wireplumber.enable) [
          (mapConfigToFiles "wireplumber/wireplumber" cfg.wireplumber.extraConfig)
        ])
      );

    xdg.dataFile = mkIf cfg.wireplumber.enable (
      concatMapAttrs (relativePath: value: {
        "${path.subpath.join [
          "wireplumber/scripts"
          relativePath
        ]}".text =
          value;
      }) cfg.wireplumber.extraScripts
    );
  };
}
