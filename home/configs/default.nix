{ ... }:

{
  imports = [
    ./desktop
    ./programs
    ./services
    ./systemd.nix
    ./xdg.nix
  ];
}
