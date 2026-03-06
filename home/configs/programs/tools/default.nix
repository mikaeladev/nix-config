{ pkgs, ... }:

{
  imports = [
    ./bun.nix
    ./fastfetch.nix
    ./ssh.nix
    ./superfile.nix
    ./zoxide.nix
  ];

  home.packages = with pkgs; [
    agenix
    nodejs
    pnpm
    rustup
  ];
}
