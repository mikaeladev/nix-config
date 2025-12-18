{ ... }:

{
  imports = [
    ./interface
    ./programs
    ./services
    ./packages.nix
    ./scripts.nix
    ./systemd.nix
    ./xdg.nix
  ];
}
