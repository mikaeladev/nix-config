{ ... }:

{
  imports = [
    ./interface
    ./programs
    ./services
    ./packages.nix
    ./systemd.nix
    ./xdg.nix
  ];
}
