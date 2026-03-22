let
  mkRenameRule =
    { name, device }:
    {
      actions.update-props = {
        "alsa.card_name" = name;
        "alsa.long_card_name" = name;
        "device.name" = name;
        "device.description" = name;
        "node.description" = name;
        "node.nick" = name;
      };
      matches = [ { "node.name" = device; } ];
    };
in

{
  services.pipewire = {
    enable = true;
    extraConfig = {
      "10-default" = {
        "default.clock.quantum" = 256;
        "default.clock.min-quantum" = 32;
        "default.clock.max-quantum" = 8192;

        "default.clock.rate" = 48000;
        "default.clock.allowed-rates" = [
          44100
          48000
          88200
          96000
          176400
          192000
        ];
      };
    };

    wireplumber = {
      enable = true;
      extraConfig = {
        # give devices friendly names
        "10-rename-devices" = {
          "monitor.alsa.rules" = [
            (mkRenameRule {
              name = "Razer Headset";
              device = "alsa_output.pci-0000_0a_00.6.analog-stereo";
            })
            (mkRenameRule {
              name = "Razer Microphone";
              device = "alsa_input.pci-0000_0a_00.6.analog-stereo";
            })
          ];
        };
        # prevent audio popping
        "20-disable-suspend" = {
          "monitor.alsa.rules" = [
            {
              actions.update-props = {
                "session.suspend-timeout-seconds" = 0;
              };
              matches = [
                { "node.name" = "~alsa_input.*"; }
                { "node.name" = "~alsa_output.*"; }
              ];
            }
          ];
        };
      };
    };
  };
}
