{ inputs }:

final: prev:

let
  args = final // {
    inherit inputs;
  };

  system = args.pkgs.stdenv.system;
in

{
  apple-emoji = import ./apple-emoji.nix args;
  apple-sf-pro = import ./apple-sf-pro.nix args;
  pixel-cursors = inputs.pixel-cursors.packages.${system}.default;
  zen-browser = inputs.zen-browser.packages.${system}.default;
}
