{ inputs, ... }:

{
  imports = [ inputs.nvibrant.homeModules.default ];

  services.nvibrant = {
    enable = true;
    arguments = [ "256" ];
  };
}
