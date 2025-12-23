{ pkgs, ... }:

{
  imports = [
    ./networking.nix
  ];

  patchDesktopFileExec = (
    beforeValue: afterValue: filePath:

    let
      inherit (pkgs) writeTextFile;

      fileName = builtins.baseNameOf filePath;
      fileText = builtins.readFile filePath;

      fileTextPatched = builtins.replaceStrings
        [ "Exec=${beforeValue}" ] [ "Exec=${afterValue}" ] fileText;
    in

    writeTextFile {
      name = fileName;
      text = fileTextPatched;
      executable = true;
    }
  );
}
