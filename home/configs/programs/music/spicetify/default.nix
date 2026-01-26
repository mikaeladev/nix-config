{
  config,
  inputs,
  pkgs,
  ...
}:

let
  inherit (config.lib.custom) wrapGraphics;

  spicePkgs = inputs.spicetify.legacyPackages.${pkgs.stdenv.system};
in

{
  imports = [ inputs.spicetify.homeManagerModules.default ];

  home.packages = [ (wrapGraphics config.programs.spicetify.spicedSpotify) ];

  programs.spicetify = {
    enable = false;
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
