{ pkgs, ... }:

{
  programs.gram = {
    enable = true;

    extensionPackages = with pkgs.zed-extensions; [
      # languages
      basher
      desktop
      git-firefly
      html
      ini
      log
      lua
      make
      neocmake
      qml
      rasi
      scheme
      scss
      tombi
      toml
      xml
      yuck

      # themes
      charmed-icons
      one-dark-pro

      # other bits
      discord-presence
    ];

    extraPackages = with pkgs; [
      nixd
      shellcheck
    ];
  };
}
