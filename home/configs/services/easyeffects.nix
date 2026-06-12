let
  mkEqBand = frequency: gain: {
    inherit frequency gain;
    mode = "RLC (BT)";
    mute = false;
    q = 1.5;
    slope = "x1";
    solo = false;
    type = "Bell";
    width = 4;
  };

  eqBands = {
    band0 = mkEqBand 32 4;
    band1 = mkEqBand 64 2;
    band2 = mkEqBand 125 1;
    band3 = mkEqBand 250 0;
    band4 = mkEqBand 500 (-1);
    band5 = mkEqBand 1000 (-2);
    band6 = mkEqBand 2000 0;
    band7 = mkEqBand 4000 2;
    band8 = mkEqBand 8000 3;
    band9 = mkEqBand 16000 3;
  };
in

{
  services.easyeffects = {
    enable = true;
    preset = "default";

    extraPresets = {
      default.output = {
        "bass_enhancer#0" = {
          amount = 0;
          blend = 0;
          bypass = false;
          floor = 20;
          floor-active = false;
          harmonics = 8.5;
          input-gain = 0;
          output-gain = 0;
          scope = 100;
        };
        "bass_loudness#0" = {
          bypass = false;
          input-gain = 0;
          link = -9;
          loudness = -3;
          output = -6;
          output-gain = -2;
        };
        "equalizer#0" = {
          balance = 0;
          bypass = false;
          input-gain = 0;
          left = eqBands;
          mode = "IIR";
          num-bands = 10;
          output-gain = 0;
          pitch-left = 0;
          pitch-right = 0;
          right = eqBands;
          split-channels = false;
        };
        "limiter#0" = {
          alr = false;
          alr-attack = 5;
          alr-knee = 0;
          alr-knee-smooth = -5;
          alr-release = 50;
          attack = 5;
          bypass = false;
          dithering = "None";
          gain-boost = true;
          input-gain = 0;
          input-to-link = 0;
          input-to-sidechain = 0;
          link-to-input = 0;
          link-to-sidechain = 0;
          lookahead = 5;
          mode = "Herm Thin";
          output-gain = 0;
          oversampling = "None";
          release = 5;
          sidechain-preamp = 0;
          sidechain-to-input = 0;
          sidechain-to-link = 0;
          sidechain-type = "Internal";
          stereo-link = 100;
          threshold = 0;
        };
        blocklist = [ ];
        plugins_order = [
          "equalizer#0"
          "bass_enhancer#0"
          "bass_loudness#0"
          "limiter#0"
        ];
      };
    };
  };
}
