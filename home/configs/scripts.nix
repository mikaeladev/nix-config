{ config, globals, lib, pkgs, ... }:

let
  inherit (lib) mkIf;
  inherit (pkgs) writeShellScriptBin;

  inherit (config.xdg) cacheHome configHome dataHome stateHome;
  
  userHome = config.home.homeDirectory;
  steamHome = "${stateHome}/steam-home";

  nvidiaSettingsBinary = (if globals.standalone
    then "/usr/bin/nvidia-settings"
    else "${config.hardware.nvidia.package.settings}/bin/nvidia-settings");
in

{
  home.packages = [
    (writeShellScriptBin "aseprite" ''
      export HOME="${steamHome}"
      exec ${userHome}/storage/steam/steamapps/common/Aseprite/aseprite "$@"
    '')

    (writeShellScriptBin "nvidia-settings" ''
      exec ${nvidiaSettingsBinary} --config="${configHome}/nvidia/settings"
    '')

    (writeShellScriptBin "restart-plasma" ''
      systemctl --user restart plasma-plasmashell
    '')

    (mkIf (!globals.standalone) (writeShellScriptBin "steam" ''
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
    ''))
  ];
}
