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
  ] ++ optionals globals.standalone [
    protonplus
  ]);
}
