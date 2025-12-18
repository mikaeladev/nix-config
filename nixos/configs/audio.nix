{ ... }:

{
  # enable realtime scheduling
  security.rtkit.enable = true;

  services = {
    # disable pulseaudio
    pulseaudio.enable = false;

    # enable pipewire with pulseaudio emulation
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };
  };
}
