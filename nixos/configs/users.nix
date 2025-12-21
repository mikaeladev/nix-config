{ globals, inputs, pkgs, ... }:

let
  inherit (globals) mainuser;
in

{
  programs.zsh = {
    enable = true;
    shellInit = ''
      export ZDOTDIR="${globals.mainuser.xdg.configHome}/zsh"
    '';
  };

  users.users.${mainuser.username} = {
    description = mainuser.nickname;
    shell = pkgs.zsh;
    isNormalUser = true;
    initialPassword = "changeme";
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
  };

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "backup";
    users.${mainuser.username} = import ../../home;
    extraSpecialArgs = {
      inherit globals inputs pkgs;
    };
  };
}
