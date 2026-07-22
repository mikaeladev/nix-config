{ config, ... }:

{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = false;
    syntaxHighlighting.enable = true;
    dotDir = config.xdg.configHome + "/zsh";

    history = {
      size = 10000;
      ignoreAllDups = true;
      path = config.xdg.stateHome + "/zsh_history";
      ignorePatterns = [
        "exit"
        "clear"
      ];
    };

    envExtra = ''
      PROMPT='[%F{yellow}%n%f@%F{yellow}%m%f:%F{yellow}%~%f]%# '
    '';
  };

  home = {
    shell.enableZshIntegration = true;

    shellAliases = {
      home-rebuild = "home-manager switch --impure";
      home-rollback = "home-manager switch --impure --rollback";
    };
  };
}
