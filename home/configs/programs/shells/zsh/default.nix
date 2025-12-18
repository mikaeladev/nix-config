{ config, ... }:

{
  programs.zsh = {
    enable = true;
    dotDir = "${config.xdg.configHome}/zsh";

    enableCompletion = false;
    autosuggestion.enable = false;
    syntaxHighlighting.enable = true;

    history.size = 10000;
    history.ignoreAllDups = true;
    history.path = "${config.xdg.stateHome}/zsh_history";
    history.ignorePatterns = [
      "exit"
      "clear"
    ];

    oh-my-zsh = {
      enable = true;
    };

    envExtra = builtins.readFile ./env.sh;
  };

  # set ZDOTDIR in /etc/zshenv
  home.file.".zshenv".enable = false;
}
