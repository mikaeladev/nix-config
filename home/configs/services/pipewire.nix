{
  services.pipewire = {
    enable = true;

    configs = {
      "10-low-latency" = {
        "context.properties" = {
          "default.clock.rate" = 48000;

          "default.clock.quantum" = 256;
          "default.clock.min-quantum" = 128;
          "default.clock.max-quantum" = 1024;

          "default.clock.allowed-rates" = [
            32000
            44100
            48000
            88200
            96000
            176400
            192000
          ];
        };
      };
    };

    pulseConfigs = {
      "10-low-latency" = {
        "context.modules" = [
          {
            "name" = "libpipewire-module-rt";
            "args" = {
              "nice.level" = -20;
              "rt.prio" = 99;
            };
          }
        ];
        "pulse.properties" = {
          "pulse.default.req" = "256/48000";
          "pulse.min.req" = "256/48000";
          "pulse.min.quantum" = "256/48000";
        };
      };
    };

    jackConfigs = {
      "10-low-latency" = {
        "jack.properties" = {
          "node.latency" = "256/48000";
          "node.quantum" = "256/48000";
        };
      };
    };

    wireplumber = {
      enable = true;
      configs =
        let
          analogOutput = "alsa_output.pci-0000_0a_00.6.analog-stereo";
          analogInput = "alsa_input.pci-0000_0a_00.6.analog-stereo";
        in
        {
          "10-low-latency" = {
            "monitor.alsa.rules" = [
              {
                "matches" = [ { "node.name" = analogOutput; } ];
                "actions"."update-props" = {
                  "device.profile" = "pro-audio";
                  "api.alsa.period-size" = 256;
                  "api.alsa.period-num" = 3;
                  "audio.rate" = 48000;
                };
              }
            ];
          };

          "20-disable-suspend" = {
            "monitor.alsa.rules" = [
              {
                "matches" = [ { "node.name" = analogOutput; } ];
                "actions"."update-props" = {
                  "session.suspend-timeout-seconds" = 0;
                };
              }
            ];
          };

          "90-rename-devices" = {
            "monitor.alsa.rules" =
              let
                mkRenameRule = { name, device }: {
                  "matches" = [ { "node.name" = device; } ];
                  "actions"."update-props" = {
                    "alsa.card_name" = name;
                    "alsa.long_card_name" = name;
                    "device.name" = name;
                    "device.description" = name;
                    "node.nick" = name;
                    "node.description" = name;
                  };
                };
              in
              [
                (mkRenameRule {
                  name = "Razer Headset";
                  device = analogOutput;
                })
                (mkRenameRule {
                  name = "Razer Headset";
                  device = analogInput;
                })
              ];
          };
        };
    };
  };
}
