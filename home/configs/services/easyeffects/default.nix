{ ... }:

{
  services.easyeffects = {
    enable = true;
    preset = "perfect eq + bass boost";
  };

  xdg.configFile."./easyeffects/output" = {
    source = builtins.toString ./presets/output;
  };
}
