{ globals, pkgs }:

let
  mkCustomLib = import ./.;
in

pkgs.lib.extend (
  self: super: {
    custom = mkCustomLib {
      inherit globals pkgs;
      lib = self;
    };
  }
)
