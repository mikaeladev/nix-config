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

  extraGroups = [
    "networkmanager"
    "wheel"
  ];
in

{
  programs.zsh = {
    enable = true;
    shellInit = ''
      if [ "$HOME" = "/home/${mainuser.username}" ]; then
        export ZDOTDIR="${mainuser.xdg.configHome}/zsh"
      fi
    '';
  };

  users.users = {
    root = {
      hashedPasswordFile = secrets."passwords/root".path;
      isSystemUser = true;
      shell = pkgs.zsh;
      uid = 0;
    };

    "${mainuser.username}" = {
      inherit extraGroups;

      description = mainuser.nickname;
      hashedPasswordFile = secrets."passwords/mainuser".path;
      isNormalUser = true;
      shell = pkgs.zsh;
      uid = 1000;
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
