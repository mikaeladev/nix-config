{ pkgs, ... }:

{
  imports = [
    ./prismlauncher.nix
    ./steam.nix
  ];

  home.packages = [
    pkgs.amethyst-mod-manager
    # count your days.......
    (pkgs.limo.override { stdenv = pkgs.gcc15Stdenv; })
  ];
}
