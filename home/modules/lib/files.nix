{ lib, pkgs, ... }:

let
  inherit (lib)
    filter
    match
    readFile
    replaceStrings
    splitString
    ;
in

{
  lib.custom = {
    updateDesktopFileValue =
      {
        key,
        value,
        source,
      }:
      let
        text = readFile source;
        lines = splitString "\n" text;
        matches = filter (str: (match "${key}=.*" str) != null) lines;
      in
      pkgs.writeTextFile {
        name = baseNameOf source;
        text = replaceStrings matches [ "${key}=${value}" ] text;
        destination = "/${source}";
        executable = true;
      }
      + "/${source}";
  };
}
