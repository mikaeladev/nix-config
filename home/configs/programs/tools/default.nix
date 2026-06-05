{ pkgs, ... }:

{
  imports = [
    ./bun.nix
    ./fastfetch.nix
    ./ssh.nix
    ./zoxide.nix
  ];

  home.packages = with pkgs; [
    agenix
    nodejs
    pnpm
    rustup
  ];
}
