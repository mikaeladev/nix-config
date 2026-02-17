{ pkgs, ... }:

{
  home.packages = with pkgs; [
    agenix
    nodejs
    pnpm
    (rust-bin.stable.latest.default.override { extensions = [ "rust-src" ]; })
  ];
}
