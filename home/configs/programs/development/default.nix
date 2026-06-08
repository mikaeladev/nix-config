{ pkgs, ... }:

{
  imports = [
    ./bun.nix
    ./zed.nix
  ];

  home.packages = with pkgs; [
    agenix
    nodejs
    pnpm
    rustup
  ];
}
