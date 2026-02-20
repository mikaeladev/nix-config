{ inputs }:

final: prev:

let
  args = final // {
    inherit inputs;
  };

  system = args.pkgs.stdenv.system;
in

{
  apple-fonts = import ./apple-fonts args;
  pixel-cursors = inputs.pixel-cursors.packages.${system}.default;
  zen-browser = inputs.zen-browser.packages.${system}.default;
}
