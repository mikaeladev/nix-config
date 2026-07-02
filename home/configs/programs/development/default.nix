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
    nodejs
    pnpm
    rustup
  ];
}
