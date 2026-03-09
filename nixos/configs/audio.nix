{ ... }:

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
    };
  };
}
