{ globals, lib, pkgs, ... }:

let
  inherit (lib) optionals;
in

{
  home.packages = with pkgs; ([
    agenix
    bun
    nodejs
    pnpm
    rust-bin.stable.latest.default
  ] ++ optionals globals.standalone [
    protonplus
  ]);
}
