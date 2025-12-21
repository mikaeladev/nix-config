{ config, globals, lib, pkgs, ... }:

let
  inherit (lib) optionals;
  inherit (pkgs) writeShellScriptBin;

  inherit (config.xdg) cacheHome configHome dataHome stateHome;

  userHome = config.home.homeDirectory;
  steamHome = "${stateHome}/steam-home";

  # makes launching from context menus possible
  asepriteWrapper = writeShellScriptBin "aseprite" ''
    export HOME="${steamHome}"
    exec "${userHome}/storage/steam/steamapps/common/Aseprite/aseprite" "$@"
  '';

  # makes nvidia-settings save to XDG_CONFIG_HOME
  nvidiaSettingsWrapper = writeShellScriptBin "nvidia-settings" ''
    exec "/usr/bin/nvidia-settings" --config="${configHome}/nvidia/settings"
  '';

  # gives steam its own home to be messy in >:(
  steamWrapper = writeShellScriptBin "steam" ''
    maybeSymlink() {
      if [ ! -e "$1" ]; then
        echo "Symlink target '$1' does not exist"
        exit 1
      elif [ ! -h "$2" ]; then
        echo "Creating symlink at '$2'"
        mkdir -p "$(dirname "$2")"
        ln -s "$1" "$2"
      elif [ ! "$1" = "$(readlink -f "$2")" ]; then
        echo "Updating symlink target at '$2'"
        ln -sf "$1" "$2"
      fi
    }

    # make steam home if it doesn't exist
    if [ ! -d "${steamHome}" ]; then
      echo "Setting up steam home in '${steamHome}'"
      mkdir -p "${steamHome}"
    fi

    # symlink xdg base dirs
    maybeSymlink "${cacheHome}" "${steamHome}/.cache"
    maybeSymlink "${configHome}" "${steamHome}/.config"
    maybeSymlink "${dataHome}" "${steamHome}/.local/share"
    maybeSymlink "${stateHome}" "${steamHome}/.local/state"

    # set new home value
    export HOME="${steamHome}"
    exec "/usr/bin/steam" "$@"
  '';
in

{
  home.packages = [
    asepriteWrapper
  ] ++ optionals globals.standalone [
    nvidiaSettingsWrapper
    steamWrapper
  ];

  home.shellAliases = {
    # really useful for when plasmashell panels glitch out
    restart-plasma = "systemctl --user restart plasma-plasmashell";
  };

  xdg.desktopEntries = {
    aseprite = {
      name = "Aseprite";
      comment = "Pixel Art Editor";
      exec = "aseprite %F";
      icon = "steam_icon_431730";
      type = "Application";
      categories = [
        "Graphics"
        "Development"
      ];
    };
  };
}
