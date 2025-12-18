{ inputs, system, ... }:

inputs.pixel-cursors.packages.${system}.default.overrideAttrs (
  _: _: {
    preBuild=''
      THEMES="default golden"
    '';
  }
)
