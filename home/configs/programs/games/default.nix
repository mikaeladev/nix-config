{ pkgs, ... }:

{
  imports = [ ./prismlauncher.nix ];

  home.packages = [ pkgs.limo ];
}
