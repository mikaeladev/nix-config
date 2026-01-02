{
  config,
  globals,
  inputs,
  lib,
  pkgs,
  ...
}@args:

{
  lib.custom = rec {
    wrapGraphics = package: (
      if globals.standalone
      then config.lib.nixGL.wrap package
      else package
    );

    wrapHome = {
      package,
      exePath ? lib.getExe package,
      binName ? baseNameOf exePath,
      xdgs ? globals.mainuser.xdg,
      newHome ? "${xdgs.stateHome}/${binName}-home",
    }: (
      let
        inherit (xdgs)
          cacheHome
          configHome
          dataHome
          stateHome
          ;
      in

      wrapPackage {
        inherit binName exePath package pkgs;

        preHook = ''
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

          if [ ! -d "${newHome}" ]; then
            echo "Setting up ${binName} home in '${newHome}'"
            mkdir -p "${newHome}"
          fi

          maybeSymlink "${cacheHome}" "${newHome}/.cache"
          maybeSymlink "${configHome}" "${newHome}/.config"
          maybeSymlink "${dataHome}" "${newHome}/.local/share"
          maybeSymlink "${stateHome}" "${newHome}/.local/state"

          export HOME="${newHome}"
        '';
      }
    );
    
    wrapPackage = { pkgs ? args.pkgs, ... }@args2: (
      inputs.wrappers.lib.wrapPackage ({ inherit pkgs; } // args2)
    );
    
    wrapStandaloneBin = binPath: (
      let
        binName = baseNameOf binPath;
      in
      
      pkgs.writeShellScriptBin binName ''
        exec -a "${binName}" "${binPath}" "$@"
      ''
    );
  };
}
