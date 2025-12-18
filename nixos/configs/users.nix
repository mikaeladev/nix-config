{ globals, inputs, pkgs, ... }:

let
  inherit (globals) mainuser;
in

{
  programs.zsh.enable = true;
  environment.etc.zshenv.text = ''
    if [ "$HOME" == "/home/${globals.mainuser.username}" ]; then
      export ZDOTDIR="${globals.mainuser.xdg.configHome}/zsh"
    fi
  '';

  users.users.${mainuser.username} = {
    description = mainuser.nickname;
    shell = mainuser.shell;
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
    users.${mainuser.username} = import ../home;
    extraSpecialArgs = {
      inherit globals inputs pkgs;
    };
  };
}
