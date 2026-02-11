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
  programs.zsh.enable = true;

  users.users = {
    root = {
      isSystemUser = true;
      hashedPasswordFile = secrets."passwords/root".path;
      shell = pkgs.zsh;
      uid = 0;
    };

    "${mainuser.username}" = {
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
    extraSpecialArgs = { inherit globals inputs pkgs; };
    users.${mainuser.username} = import ../../home;
  };
}
