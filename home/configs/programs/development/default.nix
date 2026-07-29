{ pkgs, ... }:

{
  imports = [
    ./bun.nix
    ./git.nix
    ./gram.nix
  ];

  home.packages = with pkgs; [
    agenix
    nodejs
    pnpm
    rustup
  ];
}
