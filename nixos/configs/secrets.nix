{ inputs, ... }:

{
  imports = [ inputs.agenix.nixosModules.default ];

  age.secrets = {
    "networks".file = ../secrets/networks.age;
    "passwords/root".file = ../secrets/passwords/root.age;
    "passwords/mainuser".file = ../secrets/passwords/mainuser.age;
  };
}
