{ lib, pkgs, ... }:

{
  updateDesktopFileValue =
    { key, value, source }:

    let
      oldText = builtins.readFile source;

      lines = lib.splitString "\n" oldText;

      matches = builtins.filter
        (str: (builtins.match "${key}=.*" str) != null) lines;

      newText = builtins.replaceStrings matches [ "${key}=${value}" ] oldText;
    in

    pkgs.writeTextFile {
      name = builtins.baseNameOf source;
      text = newText;
      executable = true;
    };
}
