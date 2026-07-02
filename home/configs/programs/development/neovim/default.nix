{ pkgs, ... }:

{
  imports = [
    ./options.nix
    ./plugins.nix
  ];

  programs.nixvim = {
    enable = true;
    nixpkgs.pkgs = pkgs;
  };
}
