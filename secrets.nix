let
  users = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKut+1coL3a+MOT6BU7E7Op3fkGGwbS1+k+kluaiP/ro mainuser@fedora"
    # todo: add mainuser@nixos
  ];

  systems = [
    # todo: add root@nixos
  ];
in

{
  "secrets/passwords/mainuser.age".publicKeys = users ++ systems;
  "secrets/passwords/root.age".publicKeys = users ++ systems;
  "secrets/networks.age".publicKeys = users ++ systems;
}
