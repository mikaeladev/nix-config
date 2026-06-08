{ pkgs, ... }:

{
  imports = [
    ./prismlauncher.nix
    ./steam.nix
  ];

  # count your days.......
  home.packages = [ pkgs.limo ];
}
