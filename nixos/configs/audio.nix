{ ... }:

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
  # enable realtime scheduling
  security.rtkit.enable = true;

  # enable pipewire with pulseaudio emulation
  services = {
    pulseaudio.enable = false;

    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;

      extraConfig.pipewire = {
        "10-default" = {
          "default.clock.rate" = 48000;

          "default.clock.min-quantum" = 2048;
          "default.clock-default-quantum" = 2048;
          "default.clock.max-quantum" = 4096;
          "default.clock.quantum-limit" = 4096;

          "default.clock.allowed-rates" = [
            44100
            88200
            176400
            48000
            96000
            192000
          ];
        };
      };

      wireplumber.extraConfig = {
        # prevent audio popping
        "90-disable-suspend" = {
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
        # rename audio devices
        "91-update-names" = {
          "monitor.alsa.rules" = [
            (mkRenameRule {
              name = "Monitor Speakers";
              device = "alsa_output.pci-0000_01_00.1.hdmi-stereo";
            })
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
      };
    };
  };
}
