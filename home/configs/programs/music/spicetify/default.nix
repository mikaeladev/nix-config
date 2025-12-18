{ inputs, pkgs, ... }:

let
  spicePkgs = inputs.spicetify.legacyPackages.${pkgs.stdenv.system};
in

{
  imports = [
    inputs.spicetify.homeManagerModules.default
  ];

  programs.spicetify = {
    enable = true;

    wayland = true;
    windowManagerPatch = true;

    colorScheme = "RosePine";
    theme = spicePkgs.themes.text // {
      additionalCss = builtins.readFile ./custom.css;
    };

    enabledSnippets = [
      spicePkgs.snippets.oneko
      spicePkgs.snippets.pointer
    ];
  };
}
