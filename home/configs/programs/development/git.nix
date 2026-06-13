{ config, ... }:

{
  programs.git = {
    enable = true;

    settings = {
      init.defaultBranch = "main";

      user = {
        name = "mikaeladev";
        email = "mikaeladev@icloud.com";
      };
    };

    signing = {
      format = "ssh";
      key = "${config.home.homeDirectory}/.ssh/sign_id_ed25519.pub";
      signByDefault = true;
    };
  };
}
