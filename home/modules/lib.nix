{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib) getExe getName;
  inherit (pkgs) runCommand writeShellScriptBin;
in

{
  lib.self = rec {
    patchDesktopItemExec =
      src: value:
      let
        baseName = baseNameOf src;
      in
      (runCommand baseName { } ''
        mkdir $out
        substitute '${src}' $out/'${baseName}' --replace-fail \
          "$(cat '${src}' | grep 'Exec=.*')" 'Exec=${value}'
      '')
      + "/${baseName}";

    wrapHome =
      {
        homePath ? "${config.xdg.stateHome}/${getName package}-home",
        package,
      }:
      wrapPackage {
        inherit package;

        binName = getName package;
        exePath = getExe package;

        preHook = ''
          set -euo pipefail

          __mkSymlink() {
            if [ ! -e "$1" ]; then
              echo "wrapHome: symlink target does not exist: '$1'"
              exit 1
            elif [ ! -L "$2" ] || [ ! "$1" -ef "$2" ]; then
              [ ! -d "$(dirname "$2")" ] && mkdir -p "$(dirname "$2")"
              ln -sf "$1" "$2"
              echo "wrapHome: symlinked '$2' to '$1'"
            fi
          }

          __newHome=${homePath}

          if [ ! -d "$__newHome" ]; then
            mkdir -p "$__newHome"
            echo "wrapHome: created home directory in '$__newHome'"
          fi

          __mkSymlink "$XDG_CACHE_HOME" "$__newHome"/.cache
          __mkSymlink "$XDG_CONFIG_HOME" "$__newHome"/.config
          __mkSymlink "$XDG_DATA_HOME" "$__newHome"/.local/share
          __mkSymlink "$XDG_STATE_HOME" "$__newHome"/.local/state

          export HOME="$__newHome"
          echo "wrapHome: set home directory to '$HOME'"

          unset -f __mkSymlink
          unset -v __newHome
        '';
      };

    wrapPackage =
      attrs: inputs.wrappers.lib.wrapPackage ({ inherit pkgs; } // attrs);

    wrapStandaloneBin =
      binPath:
      let
        binName = baseNameOf binPath;
      in
      writeShellScriptBin binName ''
        exec -a "${binName}" "${binPath}" "$@"
      '';

    wrapVulkan =
      package:
      wrapPackage {
        inherit package;
        env.VK_ICD_FILENAMES = "/run/opengl-driver/share/vulkan/icd.d/";
      };
  };
}
