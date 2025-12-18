{ pkgs, ... }:

{
  environment = {
    desktop = "plasma";
    
    localBinInPath = true;

    systemPackages = [
      pkgs.file
      pkgs.kitty
      pkgs.unzip
      pkgs.vim
    ];

    variables = {
      EDITOR = "vim";
      PAGER = "less";
    };
  };

  programs = {
    dconf.enable = true;
    git.enable = true;

    steam = {
      enable = true;

      extraCompatPackages = [
        pkgs.proton-ge-bin
      ];
    };
  };

  services = {
    flatpak.enable = true;
    openssh.enable = true;
  };
}
