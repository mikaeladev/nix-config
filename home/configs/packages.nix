{ globals, lib, pkgs, ... }:

let
  inherit (lib) optionals;
in

{
  home.packages = with pkgs; ([
    bun
    nodejs
    pnpm
  ] ++ optionals globals.standalone [
    protonplus
  ]);
}
