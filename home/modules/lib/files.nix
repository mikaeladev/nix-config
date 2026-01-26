{ lib, pkgs, ... }:

{
  lib.custom = {
    updateDesktopFileValue =
      {
        key,
        value,
        source,
      }:
      let
        text = builtins.readFile source;
        lines = lib.splitString "\n" text;
        matches = builtins.filter (str: (builtins.match "${key}=.*" str) != null) lines;
      in
      pkgs.writeTextFile {
        name = builtins.baseNameOf source;
        text = builtins.replaceStrings matches [ "${key}=${value}" ] text;
        executable = true;
      };
  };
}
