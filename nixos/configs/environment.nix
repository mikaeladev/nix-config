{ pkgs, ... }:

{
  desktops.plasma.enable = true;

  programs = {
    dconf.enable = true;
    git.enable = true;
    xwayland.enable = true;
    zsh.enable = true;

    steam = {
      enable = true;
      extraCompatPackages = [ pkgs.proton-ge-bin ];
    };
  };

  services = {
    flatpak.enable = true;
    openssh.enable = true;
  };

  environment = {
    localBinInPath = true;

    systemPackages = with pkgs; [
      file
      kitty
      unzip
      vim
    ];

    variables = {
      EDITOR = "vim";
      PAGER = "less";
    };
  };
}
