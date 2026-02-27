{
  config,
  globals,
  inputs,
  pkgs,
  ...
}:

let
  inherit (globals) mainuser;
  inherit (config.age) secrets;
in

{
  imports = [ inputs.home-manager.nixosModules.default ];

  users.users = {
    root = {
      isSystemUser = true;
      hashedPasswordFile = secrets."passwords/root".path;
      shell = pkgs.zsh;
      uid = 0;
    };

    ${mainuser.username} = {
      isNormalUser = true;
      description = mainuser.nickname;
      hashedPasswordFile = secrets."passwords/mainuser".path;
      shell = pkgs.zsh;
      uid = 1000;
      extraGroups = [
        "networkmanager"
        "wheel"
      ];
    };
  };

  home-manager = {
    useGlobalPkgs = false;
    useUserPackages = true;
    backupFileExtension = "backup";

    users.${mainuser.username} = import ../../home;
    extraSpecialArgs = { inherit globals inputs pkgs; };
  };
}
