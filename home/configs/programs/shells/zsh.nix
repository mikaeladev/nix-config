{ config, ... }:

{
  programs.zsh = {
    enable = true;
    enableCompletion = false;
    autosuggestion.enable = false;
    syntaxHighlighting.enable = true;
    dotDir = "${config.xdg.configHome}/zsh";

    history = {
      size = 10000;
      ignoreAllDups = true;
      path = "${config.xdg.stateHome}/zsh_history";
      ignorePatterns = [
        "exit"
        "clear"
      ];
    };

    envExtra = ''
      PROMPT='[%F{yellow}%n%f@%F{yellow}%m%f:%F{yellow}%~%f]%# '
    '';
  };
}
