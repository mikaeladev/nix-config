{ pkgs, ... }:

{
  imports = [
    ./neovim
    ./bun.nix
    ./git.nix
    ./zed.nix
  ];

  home.packages = with pkgs; [
    agenix
    gram
    nodejs
    pnpm
    rustup
  ];
}
