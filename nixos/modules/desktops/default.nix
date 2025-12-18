{ config, lib, ... }:

let
  inherit (lib) literalExpression mkOption types;

  desktopValue = config.options.environment.desktop;
in

{
  options.environment.desktop = mkOption {
    type = types.enum [ "plasma" ];
    example = literalExpression "plasma";
    description = ''
      The desktop environment to use.
    '';
  };

  imports = [
    ./${desktopValue}.nix
  ];
}
