{ inputs, ... }:

{
  imports = [ inputs.nvibrant.homeModules.default ];

  services.nvibrant = {
    enable = true;
    vibrancy = [
      "125%"
      "125%"
    ];
  };
}
