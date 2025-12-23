let
  users = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKut+1coL3a+MOT6BU7E7Op3fkGGwbS1+k+kluaiP/ro mainuser@fedora"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAZXcC0YWoYzVWJbJAXwlxgsuhaYAY/i6hkXUoWfcEt5 mainuser@nixos-desktop"
  ];

  systems = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICDrsFNUevqMg92jnQritHDnk2NIKJ+19xAfiLEg7O8F" # root@fedora
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJdC28BPIio9TPp9c9Gj4vFIWdQ/Mid0ykfJlqqhk29s root@nixos-desktop"
  ];
in

{
  "networks.age".publicKeys = users ++ systems;
}
