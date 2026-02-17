{
  globals,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib) optionals;
in

{
  home.packages =
    with pkgs;
    [
      agenix
      nodejs
      pnpm
      (rust-bin.stable.latest.default.override { extensions = [ "rust-src" ]; })
    ]
    ++ optionals globals.standalone [ protonplus ];
}
