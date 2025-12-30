{ inputs, system }:

final: prev:

let
  args = final // {
    inherit inputs system;
  };
in

{ 
  apple-fonts = import ./apple-fonts args;
  lumon-splash = import ./lumon-splash.nix args;
  pixel-cursors = import ./pixel-cursors.nix args;
}
