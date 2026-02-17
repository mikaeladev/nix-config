{ ... }:

{
  programs.bun = {
    enable = true;
    enableGitIntegration = true;

    settings = {
      telemetry = false;
    };
  };
}
