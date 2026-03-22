{
  services.easyeffects = {
    enable = true;
    preset = "default";
  };

  xdg.dataFile."easyeffects/output/default.json" = {
    source = ./presets/output.json;
  };
}
