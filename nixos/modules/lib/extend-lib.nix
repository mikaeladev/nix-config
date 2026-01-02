{ globals, inputs, pkgs }:

let
  mkCustomLib = import ./.;
in

pkgs.lib.extend (
  self: super: {
    custom = mkCustomLib {
      inherit globals inputs pkgs;
      lib = self;
    };
  }
)
